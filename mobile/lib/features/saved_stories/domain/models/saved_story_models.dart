import '../../../../core/models/story.dart';

/// Response from GET /api/bookmarks
class BookmarksResponse {
  final int total;
  final List<BookmarkItem> items;

  const BookmarksResponse({this.total = 0, this.items = const []});

  factory BookmarksResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>?;
    return BookmarksResponse(
      total: (json['total'] as num?)?.toInt() ?? 0,
      items:
          rawItems
              ?.map((e) => BookmarkItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// A single bookmark item with nested story data.
class BookmarkItem {
  final String id;
  final String storyId;
  final DateTime createdAt;
  final BookmarkedStory story;

  const BookmarkItem({
    required this.id,
    required this.storyId,
    required this.createdAt,
    required this.story,
  });

  factory BookmarkItem.fromJson(Map<String, dynamic> json) {
    return BookmarkItem(
      id: json['id'] as String,
      storyId: json['storyId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      story: BookmarkedStory.fromJson(json['story'] as Map<String, dynamic>),
    );
  }
}

/// Story data returned inside a bookmark.
class BookmarkedStory {
  final String id;
  final String slug;
  final String title;
  final String? excerpt;
  final int? readingTime;
  final int viewCount;
  final DateTime? publishedAt;
  final String? status;
  final AuthorSummary? author;
  final String? imageUrl;
  final List<TagModel> tags;
  final List<ThemeModel> themes;

  const BookmarkedStory({
    required this.id,
    required this.slug,
    required this.title,
    this.excerpt,
    this.readingTime,
    this.viewCount = 0,
    this.publishedAt,
    this.status,
    this.author,
    this.imageUrl,
    this.tags = const [],
    this.themes = const [],
  });

  factory BookmarkedStory.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tags'] as List<dynamic>?;
    final rawThemes = json['themes'] as List<dynamic>?;
    return BookmarkedStory(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String?,
      readingTime: (json['readingTime'] as num?)?.toInt(),
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'] as String)
          : null,
      status: json['status'] as String?,
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

/// Response from POST/DELETE /api/bookmarks/:storyId
class BookmarkActionResponse {
  final bool success;
  final String? message;

  const BookmarkActionResponse({this.success = false, this.message});

  factory BookmarkActionResponse.fromJson(Map<String, dynamic> json) {
    return BookmarkActionResponse(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
    );
  }
}
