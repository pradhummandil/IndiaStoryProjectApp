import 'dart:developer' as developer;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../network/api_client.dart';
import '../network/api_constants.dart';

/// Auth timing measurement result.
class AuthTimingReport {
  final String step;
  final Duration duration;

  const AuthTimingReport({required this.step, required this.duration});

  @override
  String toString() => '$step: ${duration.inMilliseconds}ms';
}

/// Production auth service:
/// 1. Sign in via Firebase Auth SDK (email/password or Google)
/// 2. Get Firebase ID token
/// 3. Send ID token to backend POST /api/auth/login
/// 4. Backend verifies token, upserts UserProfile, returns JWT
/// 5. Store JWT in secure storage for subsequent API calls
class AuthService {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  String? _token;
  Map<String, dynamic>? _currentUser;

  AuthService({
    ApiClient? apiClient,
    FlutterSecureStorage? storage,
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _apiClient = apiClient ?? ApiClient(),
       _storage = storage ?? const FlutterSecureStorage(),
       _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn();

  String? get token => _token;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isAuthenticated => _token != null && _currentUser != null;

  /// Check backend connectivity before attempting login.
  Future<bool> checkBackendConnectivity() async {
    return _apiClient.checkConnectivity();
  }

  /// Initialize from saved token (session restore)
  Future<bool> init() async {
    developer.log('AuthService.init: starting session restore', name: 'Auth');

    // Check if Firebase already has a signed-in user
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      developer.log(
        'AuthService.init: Firebase user found (${firebaseUser.email})',
        name: 'Auth',
      );
      try {
        final idToken = await firebaseUser.getIdToken(true);
        if (idToken != null) {
          developer.log(
            'AuthService.init: Firebase token refreshed, exchanging with backend',
            name: 'Auth',
          );
          return _exchangeFirebaseToken(idToken).then((_) => true).catchError((
            err,
          ) {
            developer.log(
              'AuthService.init: Token exchange failed: $err',
              name: 'Auth',
              error: err,
            );
            return false;
          });
        }
      } catch (e) {
        developer.log(
          'AuthService.init: Firebase token refresh failed: $e',
          name: 'Auth',
          error: e,
        );
      }
    } else {
      developer.log('AuthService.init: No Firebase user found', name: 'Auth');
    }

    // Fallback: try saved JWT
    final savedToken = await _storage.read(key: 'jwt_token');
    if (savedToken == null || savedToken.isEmpty) {
      developer.log('AuthService.init: No saved JWT found', name: 'Auth');
      return false;
    }

    developer.log(
      'AuthService.init: Found saved JWT, validating...',
      name: 'Auth',
    );
    _token = savedToken;
    try {
      final response = await _apiClient.get(ApiConstants.authMe);
      _currentUser = response as Map<String, dynamic>;
      developer.log('AuthService.init: JWT valid, user restored', name: 'Auth');
      return true;
    } catch (e) {
      developer.log(
        'AuthService.init: JWT invalid: $e',
        name: 'Auth',
        error: e,
      );
      _token = null;
      await _storage.delete(key: 'jwt_token');
      return false;
    }
  }

  /// Sign in with email/password via Firebase Auth + backend exchange
  Future<Map<String, dynamic>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final stopwatch = Stopwatch()..start();
    developer.log('AuthService: email/password sign-in starting', name: 'Auth');

    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final timeFirebase = stopwatch.elapsedMilliseconds;
    developer.log(
      'AuthService: Firebase signInWithEmailAndPassword completed in ${timeFirebase}ms',
      name: 'Auth',
    );

    final idToken = await credential.user?.getIdToken();
    if (idToken == null) {
      throw Exception('Failed to get Firebase ID token after login');
    }
    developer.log(
      'AuthService: Firebase ID token obtained in ${stopwatch.elapsedMilliseconds - timeFirebase}ms',
      name: 'Auth',
    );

    return _exchangeFirebaseToken(idToken);
  }

  /// Sign in with Google.
  ///
  /// On Android: uses native google_sign_in + FirebaseAuth.signInWithCredential.
  /// On Web: uses Firebase signInWithPopup.
  /// On iOS: uses native google_sign_in + FirebaseAuth.signInWithCredential.
  Future<Map<String, dynamic>> signInWithGoogle() async {
    final totalStopwatch = Stopwatch()..start();
    developer.log('AuthService: Google sign-in starting', name: 'Auth');

    String idToken;

    if (kIsWeb) {
      // Web: use signInWithPopup
      developer.log(
        'AuthService: Web platform — using signInWithPopup',
        name: 'Auth',
      );
      final googleProvider = firebase_auth.GoogleAuthProvider();
      final credential = await _firebaseAuth.signInWithPopup(googleProvider);
      final token = await credential.user?.getIdToken();
      if (token == null) {
        throw Exception(
          'Failed to get Firebase ID token from Google sign-in on web',
        );
      }
      idToken = token;
    } else {
      // Android / iOS: use native google_sign_in package only
      developer.log(
        'AuthService: Native platform — using google_sign_in library',
        name: 'Auth',
      );

      // Step 1: GoogleSignIn().signIn() — time this
      final googleSignInStopwatch = Stopwatch()..start();
      final googleUser = await _googleSignIn.signIn();
      googleSignInStopwatch.stop();
      developer.log(
        'AuthService: GoogleSignIn().signIn() took ${googleSignInStopwatch.elapsedMilliseconds}ms',
        name: 'Auth',
      );

      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled by the user');
      }

      developer.log(
        'AuthService: Google user selected: ${googleUser.email}',
        name: 'Auth',
      );

      // Step 2: Get authentication tokens
      final authStopwatch = Stopwatch()..start();
      final googleAuth = await googleUser.authentication;
      authStopwatch.stop();
      developer.log(
        'AuthService: googleUser.authentication took ${authStopwatch.elapsedMilliseconds}ms',
        name: 'Auth',
      );

      if (googleAuth.idToken == null) {
        throw Exception(
          'Failed to get Google ID token — authentication returned null',
        );
      }

      developer.log(
        'AuthService: Google ID token obtained (length: ${googleAuth.idToken!.length})',
        name: 'Auth',
      );

      // Step 3: FirebaseAuth.signInWithCredential() — time this
      final firebaseCredential = firebase_auth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final firebaseSignInStopwatch = Stopwatch()..start();
      final authResult = await _firebaseAuth.signInWithCredential(
        firebaseCredential,
      );
      firebaseSignInStopwatch.stop();
      developer.log(
        'AuthService: FirebaseAuth.signInWithCredential took ${firebaseSignInStopwatch.elapsedMilliseconds}ms',
        name: 'Auth',
      );

      // Step 4: Get Firebase ID token
      final tokenStopwatch = Stopwatch()..start();
      final token = await authResult.user?.getIdToken();
      tokenStopwatch.stop();
      developer.log(
        'AuthService: getIdToken took ${tokenStopwatch.elapsedMilliseconds}ms',
        name: 'Auth',
      );

      if (token == null) {
        throw Exception(
          'Failed to get Firebase ID token after credential exchange',
        );
      }

      idToken = token;
    }

    totalStopwatch.stop();
    developer.log(
      'AuthService: Google sign-in flow completed in ${totalStopwatch.elapsedMilliseconds}ms total',
      name: 'Auth',
    );

    return _exchangeFirebaseToken(idToken);
  }

  /// Exchange Firebase ID token for backend JWT
  Future<Map<String, dynamic>> _exchangeFirebaseToken(String idToken) async {
    final stopwatch = Stopwatch()..start();
    developer.log(
      'AuthService: Exchanging Firebase token with backend at ${ApiConstants.authLogin}',
      name: 'Auth',
    );

    final response = await _apiClient.post(
      ApiConstants.authLogin,
      data: {'idToken': idToken},
    );

    stopwatch.stop();
    developer.log(
      'AuthService: Backend token exchange took ${stopwatch.elapsedMilliseconds}ms',
      name: 'Auth',
    );

    final data = response as Map<String, dynamic>;
    _token = data['token'] as String?;
    _currentUser = data['user'] as Map<String, dynamic>?;

    if (_token != null) {
      await _storage.write(key: 'jwt_token', value: _token!);
      developer.log('AuthService: JWT token stored securely', name: 'Auth');
    } else {
      developer.log(
        'AuthService: No JWT token returned from backend!',
        name: 'Auth',
        level: 1000, // warning
      );
    }

    developer.log(
      'AuthService: User authenticated: ${_currentUser?['email'] ?? 'unknown'}',
      name: 'Auth',
    );

    return data;
  }

  /// Register with email/password via Firebase Auth + backend
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    String? name,
  }) async {
    developer.log('AuthService: Register starting for $email', name: 'Auth');
    final stopwatch = Stopwatch()..start();

    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (name != null && credential.user != null) {
      await credential.user!.updateDisplayName(name);
    }

    if (credential.user != null && !credential.user!.emailVerified) {
      await credential.user!.sendEmailVerification();
      developer.log(
        'AuthService: Verification email sent to $email',
        name: 'Auth',
      );
    }

    final idToken = await credential.user?.getIdToken();
    if (idToken == null) {
      throw Exception('Failed to get Firebase ID token after registration');
    }

    stopwatch.stop();
    developer.log(
      'AuthService: Registration + token in ${stopwatch.elapsedMilliseconds}ms',
      name: 'Auth',
    );

    return _exchangeFirebaseToken(idToken);
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    developer.log(
      'AuthService: Sending password reset to $email',
      name: 'Auth',
    );
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    developer.log('AuthService: Password reset email sent', name: 'Auth');
  }

  /// Confirm password reset
  Future<void> confirmPasswordReset(String code, String newPassword) async {
    developer.log('AuthService: Confirming password reset', name: 'Auth');
    await _firebaseAuth.confirmPasswordReset(
      code: code,
      newPassword: newPassword,
    );
    developer.log('AuthService: Password reset confirmed', name: 'Auth');
  }

  /// Sign out from Firebase + clear local state
  Future<void> signOut() async {
    developer.log('AuthService: Signing out', name: 'Auth');
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    _token = null;
    _currentUser = null;
    await _storage.delete(key: 'jwt_token');
    developer.log('AuthService: Signed out successfully', name: 'Auth');
  }
}
