class HistoryItem {
  final String id;
  final String storyId;
  final int progressPercent;
  final bool completed;
  final DateTime lastReadAt;
  final HistoryStory story;

  const HistoryItem({
    required this.id,
    required this.storyId,
    required this.progressPercent,
    required this.completed,
    required this.lastReadAt,
    required this.story,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
    id: json['id'] as String,
    storyId: json['storyId'] as String,
    progressPercent: (json['progressPercent'] as num?)?.toInt() ?? 0,
    completed: json['completed'] as bool? ?? false,
    lastReadAt: DateTime.parse(json['lastReadAt'] as String),
    story: HistoryStory.fromJson(json['story'] as Map<String, dynamic>),
  );
}

class HistoryStory {
  final String id;
  final String slug;
  final String title;
  final String? excerpt;
  final int? readingTime;
  final int viewCount;
  final String? publishedAt;
  final String? imageUrl;
  final HistoryAuthor? author;
  final String category;
  final List<String> tags;

  const HistoryStory({
    required this.id,
    required this.slug,
    required this.title,
    this.excerpt,
    this.readingTime,
    this.viewCount = 0,
    this.publishedAt,
    this.imageUrl,
    this.author,
    this.category = 'Heritage',
    this.tags = const [],
  });

  factory HistoryStory.fromJson(Map<String, dynamic> json) {
    final tags =
        (json['tags'] as List<dynamic>?)
            ?.map(
              (t) => t is Map<String, dynamic>
                  ? (t['name'] as String? ?? '')
                  : t.toString(),
            )
            .where((t) => t.isNotEmpty)
            .toList() ??
        [];
    final themes =
        (json['themes'] as List<dynamic>?)
            ?.map(
              (t) => t is Map<String, dynamic>
                  ? (t['name'] as String? ?? '')
                  : t.toString(),
            )
            .where((t) => t.isNotEmpty)
            .toList() ??
        [];
    return HistoryStory(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String?,
      readingTime: (json['readingTime'] as num?)?.toInt(),
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      publishedAt: json['publishedAt'] as String?,
      imageUrl: json['imageUrl'] as String?,
      author: json['author'] != null
          ? HistoryAuthor.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      category:
          json['category'] as String? ??
          (tags.isNotEmpty ? tags.first : 'Heritage'),
      tags: tags.isNotEmpty ? tags : themes,
    );
  }
}

class HistoryAuthor {
  final String id;
  final String name;
  final String? avatar;

  const HistoryAuthor({required this.id, required this.name, this.avatar});

  factory HistoryAuthor.fromJson(Map<String, dynamic> json) => HistoryAuthor(
    id: json['id'] as String,
    name: json['name'] as String? ?? 'Unknown',
    avatar: json['avatar'] as String?,
  );
}

class HistoryResponse {
  final List<HistoryItem> items;
  final int total;
  final int page;
  final int limit;

  const HistoryResponse({
    this.items = const [],
    this.total = 0,
    this.page = 1,
    this.limit = 20,
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) =>
      HistoryResponse(
        items:
            (json['items'] as List<dynamic>?)
                ?.map((e) => HistoryItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        total: (json['total'] as num?)?.toInt() ?? 0,
        page: (json['page'] as num?)?.toInt() ?? 1,
        limit: (json['limit'] as num?)?.toInt() ?? 20,
      );
}
