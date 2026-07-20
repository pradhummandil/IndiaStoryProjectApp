/// Backend API base URL and endpoint paths.
class ApiConstants {
  ApiConstants._();

  /// Base URL for the backend API.
  /// Update this to your production URL when deploying.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000', // Android emulator -> host localhost
  );

  /// API prefix
  static const String apiPrefix = '/api';

  // -- Endpoints ----------------------------------------------------------

  static const String home = '$apiPrefix/home';
  static const String stories = '$apiPrefix/stories';
  static const String categories = '$apiPrefix/categories';
  static const String profile = '$apiPrefix/profile';
  static const String writer = '$apiPrefix/writer';

  /// Build a story detail path from its slug.
  static String storyBySlug(String slug) => '$apiPrefix/stories/$slug';

  /// Writer endpoints
  static const String writerDashboard = '$apiPrefix/writer/dashboard';
  static const String writerStories = '$apiPrefix/writer/stories';

  /// Build a writer story detail path from its id.
  static String writerStoryById(String id) => '$apiPrefix/writer/story/$id';

  /// AI Assistant endpoints
  static const String aiAssistantContext =
      '$apiPrefix/writer/assistant/context';
  static const String aiAssistantChat = '$apiPrefix/writer/assistant/chat';
  static const String aiAssistantRewrite =
      '$apiPrefix/writer/assistant/rewrite';
  static const String aiAssistantSeo = '$apiPrefix/writer/assistant/seo';
  static const String aiAssistantTitle = '$apiPrefix/writer/assistant/title';
  static const String aiAssistantOutline =
      '$apiPrefix/writer/assistant/outline';
  static const String aiAssistantSummary =
      '$apiPrefix/writer/assistant/summary';

  /// Publish Review endpoints
  static const String publishBase = '$apiPrefix/writer/publish';

  /// Build a publish review path from its story id.
  static String publishReviewById(String storyId) =>
      '$apiPrefix/writer/publish/$storyId';

  static const String publishValidate = '$apiPrefix/writer/publish/validate';

  // -- Timeouts -----------------------------------------------------------

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
