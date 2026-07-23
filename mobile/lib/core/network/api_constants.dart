/// Backend API base URL and endpoint paths.
class ApiConstants {
  ApiConstants._();

  /// Production backend URL (Render).
  /// For local dev, override via --dart-define=API_BASE_URL=http://10.0.2.2:3000
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://isp-backend-09fw.onrender.com',
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

  // -- Search endpoints ---------------------------------------------------

  static const String search = '$apiPrefix/search';
  static const String searchSuggestions = '$apiPrefix/search/suggestions';
  static const String searchTrending = '$apiPrefix/search/trending';
  static const String searchRecent = '$apiPrefix/search/recent';

  static String searchDelete(String searchId) => '$apiPrefix/search/$searchId';

  static const String searchClear = '$apiPrefix/search';

  // -- History endpoints ---------------------------------------------------

  static const String history = '$apiPrefix/history';
  static String historyDelete(String storyId) => '$apiPrefix/history/$storyId';
  static const String historyClear = '$apiPrefix/history';

  // -- Notifications endpoints --------------------------------------------

  static const String notifications = '$apiPrefix/notifications';
  static String notificationRead(String id) =>
      '$apiPrefix/notifications/$id/read';
  static const String notificationReadAll = '$apiPrefix/notifications/read-all';
  static String notificationDelete(String id) => '$apiPrefix/notifications/$id';
  static const String notificationUnreadCount =
      '$apiPrefix/notifications/unread-count';

  // -- Auth endpoints ------------------------------------------------------

  static const String authLogin = '$apiPrefix/auth/login';
  static const String authRegister = '$apiPrefix/auth/register';
  static const String authMe = '$apiPrefix/auth/me';
  static const String authRefresh = '$apiPrefix/auth/refresh';
  static const String authLogout = '$apiPrefix/auth/logout';

  // -- Timeouts -----------------------------------------------------------

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 15);
}
