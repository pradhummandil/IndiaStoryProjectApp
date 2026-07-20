import 'package:dio/dio.dart';

import 'dio_client.dart';
import 'error_handler.dart';

/// Thin wrapper over [DioClient] that returns typed responses.
class ApiClient {
  final Dio _dio;

  ApiClient._(this._dio);

  /// Create an [ApiClient] using the shared singleton [DioClient].
  factory ApiClient() => ApiClient._(DioClient.instance.dio);

  /// Create an [ApiClient] from a custom [Dio] instance (useful for tests).
  factory ApiClient.fromDio(Dio dio) => ApiClient._(dio);

  // ── GET ────────────────────────────────────────────────────────────

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      if (e.error is ApiException) rethrow;
      throw ApiException(
        message: e.message ?? 'Unknown error',
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
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      if (e.error is ApiException) rethrow;
      throw ApiException(
        message: e.message ?? 'Unknown error',
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
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      if (e.error is ApiException) rethrow;
      throw ApiException(
        message: e.message ?? 'Unknown error',
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
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      if (e.error is ApiException) rethrow;
      throw ApiException(
        message: e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode,
        responseData: e.response?.data,
      );
    }
  }
}
