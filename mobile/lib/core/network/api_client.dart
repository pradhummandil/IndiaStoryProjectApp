import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import 'api_constants.dart';
import 'dio_client.dart';
import 'error_handler.dart';

/// Thin wrapper over [DioClient] that returns typed responses.
/// Includes request/response logging and connectivity diagnostics.
class ApiClient {
  final Dio _dio;

  ApiClient._(this._dio);

  /// Create an [ApiClient] using the shared singleton [DioClient].
  factory ApiClient() => ApiClient._(DioClient.instance.dio);

  /// Create an [ApiClient] from a custom [Dio] instance (useful for tests).
  factory ApiClient.fromDio(Dio dio) => ApiClient._(dio);

  /// Ping the backend base URL to verify connectivity before making requests.
  /// Returns true if the server is reachable.
  Future<bool> checkConnectivity({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      final response = await _dio.get(
        '/health',
        options: Options(
          sendTimeout: timeout,
          receiveTimeout: timeout,
          extra: {'noAuth': true, 'skipLogging': true},
        ),
      );
      if (response.statusCode == 200) {
        developer.log(
          'ApiClient: Backend reachable at ${ApiConstants.baseUrl}/health',
          name: 'ApiClient',
        );
        return true;
      }
      developer.log(
        'ApiClient: Backend returned ${response.statusCode} at ${ApiConstants.baseUrl}/health',
        name: 'ApiClient',
      );
      return false;
    } catch (e) {
      developer.log(
        'ApiClient: Backend unreachable at ${ApiConstants.baseUrl}/health — $e',
        name: 'ApiClient',
      );
      return false;
    }
  }

  /// Build a user-friendly error message from an exception.
  String friendlyErrorMessage(Object? error) {
    if (error is TimeoutException) {
      return 'Request timed out. Please check your internet connection and ensure the server is running at ${ApiConstants.baseUrl}';
    }
    if (error is NetworkException) {
      return 'No internet connection. Please connect to the internet and try again.';
    }
    if (error is ApiException) {
      if (error.statusCode == 401)
        return 'Session expired. Please sign in again.';
      if (error.statusCode == 500)
        return 'Server error. Please try again later.';
      if (error.message != 'Unknown error') return error.message;
    }
    if (error is DioException) {
      final path = error.requestOptions.path;
      final base = error.requestOptions.baseUrl;
      return 'Request to $base$path failed: ${error.message ?? "Unknown error"}';
    }
    return 'An unexpected error occurred. Please try again.';
  }

  // ── GET ────────────────────────────────────────────────────────────

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    developer.log('ApiClient GET $path', name: 'ApiClient');
    final stopwatch = Stopwatch()..start();
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      stopwatch.stop();
      developer.log(
        'ApiClient GET $path → ${response.statusCode} (${stopwatch.elapsedMilliseconds}ms)',
        name: 'ApiClient',
      );
      return response.data;
    } on DioException catch (e) {
      stopwatch.stop();
      final endpoint =
          '$path${queryParameters != null ? '?$queryParameters' : ''}';
      developer.log(
        'ApiClient GET $endpoint FAILED (${stopwatch.elapsedMilliseconds}ms): ${e.message}',
        name: 'ApiClient',
        error: e.error,
      );
      if (e.error is ApiException) rethrow;
      throw ApiException(
        message: 'Request to $path failed: ${e.message ?? 'Unknown error'}',
        statusCode: e.response?.statusCode,
        responseData: e.response?.data,
      );
    }
  }

  // ── POST ───────────────────────────────────────────────────────────

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    developer.log('ApiClient POST $path', name: 'ApiClient');
    final stopwatch = Stopwatch()..start();
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      stopwatch.stop();
      developer.log(
        'ApiClient POST $path → ${response.statusCode} (${stopwatch.elapsedMilliseconds}ms)',
        name: 'ApiClient',
      );
      return response.data;
    } on DioException catch (e) {
      stopwatch.stop();
      developer.log(
        'ApiClient POST $path FAILED (${stopwatch.elapsedMilliseconds}ms): ${e.message}',
        name: 'ApiClient',
        error: e.error,
      );
      if (e.error is ApiException) rethrow;
      throw ApiException(
        message: 'Request to $path failed: ${e.message ?? 'Unknown error'}',
        statusCode: e.response?.statusCode,
        responseData: e.response?.data,
      );
    }
  }

  // ── PUT ────────────────────────────────────────────────────────────

  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    developer.log('ApiClient PUT $path', name: 'ApiClient');
    final stopwatch = Stopwatch()..start();
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      stopwatch.stop();
      developer.log(
        'ApiClient PUT $path → ${response.statusCode} (${stopwatch.elapsedMilliseconds}ms)',
        name: 'ApiClient',
      );
      return response.data;
    } on DioException catch (e) {
      stopwatch.stop();
      developer.log(
        'ApiClient PUT $path FAILED (${stopwatch.elapsedMilliseconds}ms): ${e.message}',
        name: 'ApiClient',
        error: e.error,
      );
      if (e.error is ApiException) rethrow;
      throw ApiException(
        message: 'Request to $path failed: ${e.message ?? 'Unknown error'}',
        statusCode: e.response?.statusCode,
        responseData: e.response?.data,
      );
    }
  }

  // ── PATCH ─────────────────────────────────────────────────────────

  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    developer.log('ApiClient PATCH $path', name: 'ApiClient');
    final stopwatch = Stopwatch()..start();
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      stopwatch.stop();
      developer.log(
        'ApiClient PATCH $path → ${response.statusCode} (${stopwatch.elapsedMilliseconds}ms)',
        name: 'ApiClient',
      );
      return response.data;
    } on DioException catch (e) {
      stopwatch.stop();
      developer.log(
        'ApiClient PATCH $path FAILED (${stopwatch.elapsedMilliseconds}ms): ${e.message}',
        name: 'ApiClient',
        error: e.error,
      );
      if (e.error is ApiException) rethrow;
      throw ApiException(
        message: 'Request to $path failed: ${e.message ?? 'Unknown error'}',
        statusCode: e.response?.statusCode,
        responseData: e.response?.data,
      );
    }
  }

  // ── DELETE ─────────────────────────────────────────────────────────

  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    developer.log('ApiClient DELETE $path', name: 'ApiClient');
    final stopwatch = Stopwatch()..start();
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
      );
      stopwatch.stop();
      developer.log(
        'ApiClient DELETE $path → ${response.statusCode} (${stopwatch.elapsedMilliseconds}ms)',
        name: 'ApiClient',
      );
      return response.data;
    } on DioException catch (e) {
      stopwatch.stop();
      developer.log(
        'ApiClient DELETE $path FAILED (${stopwatch.elapsedMilliseconds}ms): ${e.message}',
        name: 'ApiClient',
        error: e.error,
      );
      if (e.error is ApiException) rethrow;
      throw ApiException(
        message: 'Request to $path failed: ${e.message ?? 'Unknown error'}',
        statusCode: e.response?.statusCode,
        responseData: e.response?.data,
      );
    }
  }
}
