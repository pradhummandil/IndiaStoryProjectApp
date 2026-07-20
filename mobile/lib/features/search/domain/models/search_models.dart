// ── Search Suggestion Item ────────────────────────────────────────────

class SearchSuggestion {
  final String query;
  final int count;

  const SearchSuggestion({required this.query, this.count = 0});

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) =>
      SearchSuggestion(
        query: json['query'] as String? ?? json['title'] as String? ?? '',
        count: (json['count'] as num?)?.toInt() ?? 0,
      );

  factory SearchSuggestion.fromTitle(String title) =>
      SearchSuggestion(query: title, count: 0);
}

// ── Recent Search Item (from SearchHistory) ───────────────────────────

class RecentSearchItem {
  final String id;
  final String query;
  final DateTime createdAt;

  const RecentSearchItem({
    required this.id,
    required this.query,
    required this.createdAt,
  });

  factory RecentSearchItem.fromJson(Map<String, dynamic> json) =>
      RecentSearchItem(
        id: json['id'] as String,
        query: json['query'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

// ── Trending Topic ────────────────────────────────────────────────────

class TrendingTopic {
  final String id;
  final String query;
  final int count;

  const TrendingTopic({required this.id, required this.query, this.count = 0});

  factory TrendingTopic.fromJson(Map<String, dynamic> json) => TrendingTopic(
    id: json['id'] as String,
    query: json['query'] as String,
    count: (json['count'] as num?)?.toInt() ?? 0,
  );
}

// ── Suggestion / Trending Search Response (flat list) ─────────────────

class SearchSuggestionsResponse {
  final List<String> suggestions;

  const SearchSuggestionsResponse({this.suggestions = const []});

  factory SearchSuggestionsResponse.fromJson(dynamic json) {
    if (json is List) {
      return SearchSuggestionsResponse(
        suggestions: json.map((e) => e.toString()).toList(),
      );
    }
    return const SearchSuggestionsResponse();
  }
}

class TrendingResponse {
  final List<TrendingTopic> items;

  const TrendingResponse({this.items = const []});

  factory TrendingResponse.fromJson(dynamic json) {
    if (json is List) {
      return TrendingResponse(
        items: json
            .map((e) => TrendingTopic.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }
    return const TrendingResponse();
  }
}

// ── Full Search Response (from GET /api/search) ───────────────────────

class FullSearchResponse {
  final List<dynamic> storyItems;
  final int totalStories;
  final int page;
  final int limit;
  final List<TrendingTopic> trending;
  final List<RecentSearchItem> recentSearches;
  final List<String> suggestions;

  const FullSearchResponse({
    this.storyItems = const [],
    this.totalStories = 0,
    this.page = 1,
    this.limit = 10,
    this.trending = const [],
    this.recentSearches = const [],
    this.suggestions = const [],
  });

  factory FullSearchResponse.fromJson(Map<String, dynamic> json) {
    final storiesData = json['stories'] as Map<String, dynamic>?;
    final rawTrending = json['trending'] as List<dynamic>?;
    final rawRecent = json['recentSearches'] as List<dynamic>?;
    final rawSuggestions = json['suggestions'] as List<dynamic>?;

    return FullSearchResponse(
      storyItems: storiesData?['items'] as List<dynamic>? ?? [],
      totalStories: (storiesData?['total'] as num?)?.toInt() ?? 0,
      page: (storiesData?['page'] as num?)?.toInt() ?? 1,
      limit: (storiesData?['limit'] as num?)?.toInt() ?? 10,
      trending:
          rawTrending
              ?.map((e) => TrendingTopic.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentSearches:
          rawRecent
              ?.map((e) => RecentSearchItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      suggestions: rawSuggestions?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
