import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_constants.dart';
import 'error_handler.dart';

/// Singleton [Dio] client with:
/// - Base URL & timeouts
/// - Auth interceptor (reads JWT from secure storage)
/// - Request/response logging interceptor
/// - Error mapper
class DioClient {
  static DioClient? _instance;
  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  DioClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(_loggingInterceptor());
    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(_errorInterceptor());
  }

  /// Returns the singleton instance.
  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }

  Dio get dio => _dio;

  // ── Interceptors ───────────────────────────────────────────────────

  LogInterceptor _loggingInterceptor() {
    return LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
      logPrint: (obj) {
        developer.log('$obj', name: 'DioClient');
      },
    );
  }

  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Skip auth for health check and auth endpoints
        if (options.extra['noAuth'] == true) {
          handler.next(options);
          return;
        }

        final path = options.path;
        if (path.contains('/auth/') || path.contains('/health')) {
          handler.next(options);
          return;
        }

        // Read JWT from secure storage
        final token = await _storage.read(key: 'jwt_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
          developer.log('Attached JWT token to request', name: 'DioClient');
        } else {
          developer.log('No JWT token available', name: 'DioClient');
        }
        handler.next(options);
      },
    );
  }

  InterceptorsWrapper _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          developer.log(
            'Timeout error: ${error.requestOptions.path}',
            name: 'DioClient',
            error: error,
          );
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: const TimeoutException(),
            ),
          );
        }

        if (error.type == DioExceptionType.connectionError) {
          developer.log(
            'Connection error: ${error.requestOptions.path}',
            name: 'DioClient',
            error: error,
          );
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: const NetworkException(),
            ),
          );
        }

        // Map HTTP status codes
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          developer.log(
            'HTTP $statusCode: ${error.requestOptions.path}',
            name: 'DioClient',
            error: error,
          );
          final apiException = httpErrorFromStatusCode(
            statusCode,
            error.response?.data,
          );
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: apiException,
              response: error.response,
            ),
          );
        }

        handler.next(error);
      },
    );
  }

  /// Convenience method to clear stored token (on logout).
  Future<void> clearToken() async {
    await _storage.delete(key: 'jwt_token');
    developer.log('JWT token cleared', name: 'DioClient');
  }

  /// Convenience method to store token (on login).
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
    developer.log('JWT token saved', name: 'DioClient');
  }
}
