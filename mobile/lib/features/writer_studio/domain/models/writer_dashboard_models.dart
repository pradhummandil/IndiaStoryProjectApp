// ── Writer Dashboard Stats ───────────────────────────────────────────

class WriterDashboardStats {
  final int totalReads;
  final int avgReadingTime;
  final int totalViews;
  final int totalLikes;
  final int totalBookmarks;
  final int totalReadingTime;
  final int completionRate;
  final int draftCount;
  final int publishedCount;

  const WriterDashboardStats({
    this.totalReads = 0,
    this.avgReadingTime = 0,
    this.totalViews = 0,
    this.totalLikes = 0,
    this.totalBookmarks = 0,
    this.totalReadingTime = 0,
    this.completionRate = 0,
    this.draftCount = 0,
    this.publishedCount = 0,
  });

  factory WriterDashboardStats.fromJson(Map<String, dynamic> json) =>
      WriterDashboardStats(
        totalReads: (json['totalReads'] as num?)?.toInt() ?? 0,
        avgReadingTime: (json['avgReadingTime'] as num?)?.toInt() ?? 0,
        totalViews: (json['totalViews'] as num?)?.toInt() ?? 0,
        totalLikes: (json['totalLikes'] as num?)?.toInt() ?? 0,
        totalBookmarks: (json['totalBookmarks'] as num?)?.toInt() ?? 0,
        totalReadingTime: (json['totalReadingTime'] as num?)?.toInt() ?? 0,
        completionRate: (json['completionRate'] as num?)?.toInt() ?? 0,
        draftCount: (json['draftCount'] as num?)?.toInt() ?? 0,
        publishedCount: (json['publishedCount'] as num?)?.toInt() ?? 0,
      );
}

// ── Writer Story Item ────────────────────────────────────────────────

class WriterStoryItem {
  final String id;
  final String slug;
  final String title;
  final String? excerpt;
  final String status;
  final int? readingTime;
  final int viewCount;
  final DateTime? publishedAt;
  final DateTime updatedAt;
  final String? imageUrl;
  final WriterAuthorSummary? author;
  final int likesCount;
  final int bookmarksCount;

  const WriterStoryItem({
    required this.id,
    required this.slug,
    required this.title,
    this.excerpt,
    this.status = 'Draft',
    this.readingTime,
    this.viewCount = 0,
    this.publishedAt,
    required this.updatedAt,
    this.imageUrl,
    this.author,
    this.likesCount = 0,
    this.bookmarksCount = 0,
  });

  factory WriterStoryItem.fromJson(Map<String, dynamic> json) {
    return WriterStoryItem(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String?,
      status: (json['status'] as String?) ?? 'Draft',
      readingTime: (json['readingTime'] as num?)?.toInt(),
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'] as String)
          : null,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      imageUrl: json['imageUrl'] as String?,
      author: json['author'] != null
          ? WriterAuthorSummary.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      bookmarksCount: (json['bookmarksCount'] as num?)?.toInt() ?? 0,
    );
  }
}

// ── Writer Author Summary ────────────────────────────────────────────

class WriterAuthorSummary {
  final String id;
  final String name;
  final String? avatar;

  const WriterAuthorSummary({
    required this.id,
    required this.name,
    this.avatar,
  });

  factory WriterAuthorSummary.fromJson(Map<String, dynamic> json) =>
      WriterAuthorSummary(
        id: json['id'] as String,
        name: json['name'] as String,
        avatar: json['avatar'] as String?,
      );
}

// ── Writer Analytics ─────────────────────────────────────────────────

class WriterAnalytics {
  final int viewsToday;
  final int viewsThisWeek;
  final int viewsThisMonth;
  final int likesToday;
  final int likesThisWeek;
  final int likesThisMonth;

  const WriterAnalytics({
    this.viewsToday = 0,
    this.viewsThisWeek = 0,
    this.viewsThisMonth = 0,
    this.likesToday = 0,
    this.likesThisWeek = 0,
    this.likesThisMonth = 0,
  });

  factory WriterAnalytics.fromJson(Map<String, dynamic> json) =>
      WriterAnalytics(
        viewsToday: (json['viewsToday'] as num?)?.toInt() ?? 0,
        viewsThisWeek: (json['viewsThisWeek'] as num?)?.toInt() ?? 0,
        viewsThisMonth: (json['viewsThisMonth'] as num?)?.toInt() ?? 0,
        likesToday: (json['likesToday'] as num?)?.toInt() ?? 0,
        likesThisWeek: (json['likesThisWeek'] as num?)?.toInt() ?? 0,
        likesThisMonth: (json['likesThisMonth'] as num?)?.toInt() ?? 0,
      );
}

// ── Writer Achievements ──────────────────────────────────────────────

class WriterAchievements {
  final int totalStories;
  final int totalViews;
  final int totalLikes;
  final int totalReadingTime;
  final int level;
  final int xp;
  final int xpNext;

  const WriterAchievements({
    this.totalStories = 0,
    this.totalViews = 0,
    this.totalLikes = 0,
    this.totalReadingTime = 0,
    this.level = 1,
    this.xp = 0,
    this.xpNext = 100,
  });

  factory WriterAchievements.fromJson(Map<String, dynamic> json) =>
      WriterAchievements(
        totalStories: (json['totalStories'] as num?)?.toInt() ?? 0,
        totalViews: (json['totalViews'] as num?)?.toInt() ?? 0,
        totalLikes: (json['totalLikes'] as num?)?.toInt() ?? 0,
        totalReadingTime: (json['totalReadingTime'] as num?)?.toInt() ?? 0,
        level: (json['level'] as num?)?.toInt() ?? 1,
        xp: (json['xp'] as num?)?.toInt() ?? 0,
        xpNext: (json['xpNext'] as num?)?.toInt() ?? 100,
      );
}

// ── Writer Dashboard Response ────────────────────────────────────────

class WriterDashboardResponse {
  final WriterDashboardStats stats;
  final List<WriterStoryItem> drafts;
  final List<WriterStoryItem> published;
  final List<WriterStoryItem> recentStories;
  final WriterAnalytics analytics;
  final WriterAchievements achievements;

  const WriterDashboardResponse({
    required this.stats,
    this.drafts = const [],
    this.published = const [],
    this.recentStories = const [],
    required this.analytics,
    required this.achievements,
  });

  factory WriterDashboardResponse.fromJson(Map<String, dynamic> json) {
    final rawDrafts = json['drafts'] as List<dynamic>?;
    final rawPublished = json['published'] as List<dynamic>?;
    final rawRecent = json['recentStories'] as List<dynamic>?;

    return WriterDashboardResponse(
      stats: WriterDashboardStats.fromJson(
        json['stats'] as Map<String, dynamic>,
      ),
      drafts:
          rawDrafts
              ?.map((e) => WriterStoryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      published:
          rawPublished
              ?.map((e) => WriterStoryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentStories:
          rawRecent
              ?.map((e) => WriterStoryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      analytics: WriterAnalytics.fromJson(
        json['analytics'] as Map<String, dynamic>,
      ),
      achievements: WriterAchievements.fromJson(
        json['achievements'] as Map<String, dynamic>,
      ),
    );
  }
}
