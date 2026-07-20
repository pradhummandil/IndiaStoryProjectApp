import 'story.dart';

// ── Continue Reading Item ────────────────────────────────────────────

class ContinueReadingItem {
  final int progressPercent;
  final DateTime lastReadAt;
  final bool completed;
  final StoryListItem story;

  const ContinueReadingItem({
    required this.progressPercent,
    required this.lastReadAt,
    required this.completed,
    required this.story,
  });

  factory ContinueReadingItem.fromJson(Map<String, dynamic> json) =>
      ContinueReadingItem(
        progressPercent: (json['progressPercent'] as num?)?.toInt() ?? 0,
        lastReadAt: DateTime.parse(json['lastReadAt'] as String),
        completed: json['completed'] as bool? ?? false,
        story: StoryListItem.fromJson(json['story'] as Map<String, dynamic>),
      );
}

// ── Category Item (from /api/categories or /api/home) ────────────────

class CategoryItem {
  final String id;
  final String name;
  final String slug;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
    id: json['id'] as String,
    name: json['name'] as String,
    slug: json['slug'] as String,
  );
}

// ── Collection Item ──────────────────────────────────────────────────

class CollectionItem {
  final String id;
  final String name;
  final String userId;
  final DateTime createdAt;
  final List<StoryListItem> stories;

  const CollectionItem({
    required this.id,
    required this.name,
    required this.userId,
    required this.createdAt,
    this.stories = const [],
  });

  factory CollectionItem.fromJson(Map<String, dynamic> json) {
    final rawStories = json['stories'] as List<dynamic>?;

    return CollectionItem(
      id: json['id'] as String,
      name: json['name'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      stories:
          rawStories
              ?.map((e) => StoryListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// ── Home Response (top-level) ────────────────────────────────────────

class HomeResponse {
  final StoryListItem? featuredStory;
  final List<StoryListItem> latestStories;
  final List<ContinueReadingItem> continueReading;
  final List<StoryListItem> trendingStories;
  final List<CategoryItem> categories;
  final List<CollectionItem> collections;

  const HomeResponse({
    this.featuredStory,
    this.latestStories = const [],
    this.continueReading = const [],
    this.trendingStories = const [],
    this.categories = const [],
    this.collections = const [],
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      featuredStory: json['featuredStory'] != null
          ? StoryListItem.fromJson(
              json['featuredStory'] as Map<String, dynamic>,
            )
          : null,
      latestStories: _parseStoryList(json['latestStories']),
      continueReading:
          (json['continueReading'] as List<dynamic>?)
              ?.map(
                (e) => ContinueReadingItem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      trendingStories: _parseStoryList(json['trendingStories']),
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => CategoryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      collections:
          (json['collections'] as List<dynamic>?)
              ?.map((e) => CollectionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  static List<StoryListItem> _parseStoryList(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .map((e) => StoryListItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
