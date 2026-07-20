// ── Author ───────────────────────────────────────────────────────────

class AuthorSummary {
  final String id;
  final String name;
  final String? avatar;
  final String? bio;

  const AuthorSummary({
    required this.id,
    required this.name,
    this.avatar,
    this.bio,
  });

  factory AuthorSummary.fromJson(Map<String, dynamic> json) => AuthorSummary(
    id: json['id'] as String,
    name: json['name'] as String,
    avatar: json['avatar'] as String?,
    bio: json['bio'] as String?,
  );
}

// ── Tag / Theme ──────────────────────────────────────────────────────

class TagModel {
  final String id;
  final String name;
  final String slug;

  const TagModel({required this.id, required this.name, required this.slug});

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
    id: json['id'] as String,
    name: json['name'] as String,
    slug: json['slug'] as String,
  );
}

class ThemeModel {
  final String id;
  final String name;
  final String slug;

  const ThemeModel({required this.id, required this.name, required this.slug});

  factory ThemeModel.fromJson(Map<String, dynamic> json) => ThemeModel(
    id: json['id'] as String,
    name: json['name'] as String,
    slug: json['slug'] as String,
  );
}

// ── Story Image ──────────────────────────────────────────────────────

class StoryImageModel {
  final String imageUrl;
  final int sortOrder;
  final String? caption;

  const StoryImageModel({
    required this.imageUrl,
    required this.sortOrder,
    this.caption,
  });

  factory StoryImageModel.fromJson(Map<String, dynamic> json) =>
      StoryImageModel(
        imageUrl: json['imageUrl'] as String,
        sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
        caption: json['caption'] as String?,
      );
}

// ── Story List Item (used in /api/stories list and /api/home) ────────

class StoryListItem {
  final String id;
  final String slug;
  final String title;
  final String? excerpt;
  final int? readingTime;
  final int viewCount;
  final DateTime? publishedAt;
  final AuthorSummary? author;
  final String? imageUrl;
  final List<TagModel> tags;
  final List<ThemeModel> themes;

  const StoryListItem({
    required this.id,
    required this.slug,
    required this.title,
    this.excerpt,
    this.readingTime,
    this.viewCount = 0,
    this.publishedAt,
    this.author,
    this.imageUrl,
    this.tags = const [],
    this.themes = const [],
  });

  factory StoryListItem.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tags'] as List<dynamic>?;
    final rawThemes = json['themes'] as List<dynamic>?;

    return StoryListItem(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String?,
      readingTime: (json['readingTime'] as num?)?.toInt(),
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'] as String)
          : null,
      author: json['author'] != null
          ? AuthorSummary.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      imageUrl: json['imageUrl'] as String?,
      tags:
          rawTags
              ?.map((e) => TagModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      themes:
          rawThemes
              ?.map((e) => ThemeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// ── Story Detail (used in /api/stories/:slug) ────────────────────────

class StateInfo {
  final String? slug;
  final String? name;

  const StateInfo({this.slug, this.name});

  factory StateInfo.fromJson(Map<String, dynamic> json) =>
      StateInfo(slug: json['slug'] as String?, name: json['name'] as String?);
}

class CityInfo {
  final String? slug;
  final String? name;

  const CityInfo({this.slug, this.name});

  factory CityInfo.fromJson(Map<String, dynamic> json) =>
      CityInfo(slug: json['slug'] as String?, name: json['name'] as String?);
}

class StoryDetail {
  final String id;
  final String slug;
  final String title;
  final String? excerpt;
  final String? contentHi;
  final String? titleHi;
  final String? excerptHi;
  final int? readingTime;
  final DateTime? publishedAt;
  final String? seoTitle;
  final String? seoDescription;
  final String? seoKeywords;
  final int viewCount;
  final List<StoryImageModel> images;
  final List<TagModel> tags;
  final List<ThemeModel> themes;

  const StoryDetail({
    required this.id,
    required this.slug,
    required this.title,
    this.excerpt,
    this.contentHi,
    this.titleHi,
    this.excerptHi,
    this.readingTime,
    this.publishedAt,
    this.seoTitle,
    this.seoDescription,
    this.seoKeywords,
    this.viewCount = 0,
    this.images = const [],
    this.tags = const [],
    this.themes = const [],
  });

  factory StoryDetail.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'] as List<dynamic>?;
    final rawTags = json['tags'] as List<dynamic>?;
    final rawThemes = json['themes'] as List<dynamic>?;

    return StoryDetail(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String?,
      contentHi: json['contentHi'] as String?,
      titleHi: json['titleHi'] as String?,
      excerptHi: json['excerptHi'] as String?,
      readingTime: (json['readingTime'] as num?)?.toInt(),
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'] as String)
          : null,
      seoTitle: json['seoTitle'] as String?,
      seoDescription: json['seoDescription'] as String?,
      seoKeywords: json['seoKeywords'] as String?,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      images:
          rawImages
              ?.map((e) => StoryImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tags:
          rawTags
              ?.map((e) => TagModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      themes:
          rawThemes
              ?.map((e) => ThemeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// ── Reading Statistics ───────────────────────────────────────────────

class ReadingStatistics {
  final int viewCount;
  final int bookmarkCount;
  final int likesCount;
  final int readingProgressCount;

  const ReadingStatistics({
    this.viewCount = 0,
    this.bookmarkCount = 0,
    this.likesCount = 0,
    this.readingProgressCount = 0,
  });

  factory ReadingStatistics.fromJson(Map<String, dynamic> json) =>
      ReadingStatistics(
        viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
        bookmarkCount: (json['bookmarkCount'] as num?)?.toInt() ?? 0,
        likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
        readingProgressCount:
            (json['readingProgressCount'] as num?)?.toInt() ?? 0,
      );
}

// ── Category Info (state/city) ───────────────────────────────────────

class StoryCategory {
  final StateInfo? state;
  final CityInfo? city;

  const StoryCategory({this.state, this.city});

  factory StoryCategory.fromJson(Map<String, dynamic> json) => StoryCategory(
    state: json['state'] != null
        ? StateInfo.fromJson(json['state'] as Map<String, dynamic>)
        : null,
    city: json['city'] != null
        ? CityInfo.fromJson(json['city'] as Map<String, dynamic>)
        : null,
  );
}

// ── Story Detail Response (top-level) ────────────────────────────────

class StoryDetailResponse {
  final StoryDetail story;
  final AuthorSummary author;
  final StoryCategory category;
  final List<StoryListItem> relatedStories;
  final ReadingStatistics readingStatistics;

  const StoryDetailResponse({
    required this.story,
    required this.author,
    required this.category,
    this.relatedStories = const [],
    required this.readingStatistics,
  });

  factory StoryDetailResponse.fromJson(Map<String, dynamic> json) {
    final rawRelated = json['relatedStories'] as List<dynamic>?;

    return StoryDetailResponse(
      story: StoryDetail.fromJson(json['story'] as Map<String, dynamic>),
      author: AuthorSummary.fromJson(json['author'] as Map<String, dynamic>),
      category: StoryCategory.fromJson(
        json['category'] as Map<String, dynamic>,
      ),
      relatedStories:
          rawRelated
              ?.map((e) => StoryListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      readingStatistics: ReadingStatistics.fromJson(
        json['readingStatistics'] as Map<String, dynamic>,
      ),
    );
  }
}
