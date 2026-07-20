import '../models/stories_response.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../../features/search/domain/models/search_models.dart';

class SearchRepository {
  final ApiClient _client;

  SearchRepository(this._client);

  /// Full search — returns stories, trending, recent, suggestions.
  Future<FullSearchResponse> search({
    String query = '',
    String? category,
    String? region,
    String? sort,
    int page = 1,
    int limit = 10,
  }) async {
    final params = <String, dynamic>{'q': query, 'page': page, 'limit': limit};
    if (category != null) params['category'] = category;
    if (region != null) params['region'] = region;
    if (sort != null) params['sort'] = sort;

    final json = await _client.get(
      ApiConstants.search,
      queryParameters: params,
    );
    return FullSearchResponse.fromJson(json as Map<String, dynamic>);
  }

  /// Fetch suggestions for autocomplete.
  Future<List<String>> getSuggestions(String query) async {
    if (query.trim().length < 2) return [];
    final json = await _client.get(
      ApiConstants.searchSuggestions,
      queryParameters: {'q': query},
    );
    return SearchSuggestionsResponse.fromJson(json).suggestions;
  }

  /// Fetch trending searches.
  Future<List<TrendingTopic>> getTrending() async {
    final json = await _client.get(ApiConstants.searchTrending);
    return TrendingResponse.fromJson(json).items;
  }

  /// Fetch recent searches for authenticated user.
  Future<List<RecentSearchItem>> getRecentSearches() async {
    final json = await _client.get(ApiConstants.searchRecent);
    if (json is List) {
      return json
          .map((e) => RecentSearchItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Delete a specific search history item.
  Future<void> deleteSearch(String searchId) async {
    await _client.delete(ApiConstants.searchDelete(searchId));
  }

  /// Clear all search history.
  Future<void> clearSearchHistory() async {
    await _client.delete(ApiConstants.searchClear);
  }
}
