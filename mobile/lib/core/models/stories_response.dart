import 'story.dart';

/// Paginated response for `GET /api/stories`.
class StoriesResponse {
  final int page;
  final int limit;
  final int total;
  final List<StoryListItem> items;

  const StoriesResponse({
    required this.page,
    required this.limit,
    required this.total,
    this.items = const [],
  });

  bool get hasMore => page * limit < total;

  factory StoriesResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>?;

    return StoriesResponse(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      items:
          rawItems
              ?.map((e) => StoryListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
