import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'auth_service.dart';

// ── Auth State ───────────────────────────────────────────────────────

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final Map<String, dynamic>? user;
  final String? error;
  final String? token;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.error,
    this.token,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    Map<String, dynamic>? user,
    String? error,
    String? token,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: clearUser ? null : (user ?? this.user),
      error: clearError ? null : (error ?? this.error),
      token: token ?? this.token,
    );
  }
}

// ── Auth Notifier ────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState());

  /// Attempt to restore session from saved token on app start.
  Future<void> tryAutoLogin() async {
    state = AuthState(isLoading: true);
    final restored = await _authService.init();
    if (restored &&
        _authService.token != null &&
        _authService.currentUser != null) {
      state = AuthState(
        isAuthenticated: true,
        user: _authService.currentUser,
        token: _authService.token,
      );
    } else {
      state = const AuthState();
    }
  }

  /// Sign in with email/password.
  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = AuthState(isLoading: true);
    try {
      final result = await _authService.signInWithEmailPassword(
        email: email,
        password: password,
      );
      state = AuthState(
        isAuthenticated: true,
        user: result['user'] as Map<String, dynamic>?,
        token: result['token'] as String?,
      );
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  /// Sign in with Google via Firebase Auth
  Future<void> signInWithGoogle() async {
    state = AuthState(isLoading: true);
    try {
      final result = await _authService.signInWithGoogle();
      state = AuthState(
        isAuthenticated: true,
        user: result['user'] as Map<String, dynamic>?,
        token: result['token'] as String?,
      );
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  /// Register a new user.
  Future<void> register({
    required String email,
    required String password,
    String? name,
  }) async {
    state = AuthState(isLoading: true);
    try {
      final result = await _authService.register(
        email: email,
        password: password,
        name: name,
      );
      state = AuthState(
        isAuthenticated: true,
        user: result['user'] as Map<String, dynamic>?,
        token: result['token'] as String?,
      );
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  /// Send password reset email via Firebase Auth.
  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  /// Sign out.
  Future<void> signOut() async {
    await _authService.signOut();
    state = const AuthState();
  }

  /// Clear error.
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

// ── Provider ─────────────────────────────────────────────────────────

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
