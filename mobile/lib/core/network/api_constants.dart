/// Backend API base URL and endpoint paths.
class ApiConstants {
  ApiConstants._();

  /// Base URL for the backend API.
  /// Update this to your production URL when deploying.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000', // Android emulator → host localhost
  );

  /// API prefix
  static const String apiPrefix = '/api';

  // ── Endpoints ──────────────────────────────────────────────────────

  static const String home = '$apiPrefix/home';
  static const String stories = '$apiPrefix/stories';
  static const String categories = '$apiPrefix/categories';
  static const String profile = '$apiPrefix/profile';

  /// Build a story detail path from its slug.
  static String storyBySlug(String slug) => '$apiPrefix/stories/$slug';

  // ── Timeouts ───────────────────────────────────────────────────────

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
