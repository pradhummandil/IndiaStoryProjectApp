import '../models/stories_response.dart';
import '../models/story.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';

class StoryRepository {
  final ApiClient _client;

  StoryRepository(this._client);

  /// Fetch paginated stories with optional filters.
  Future<StoriesResponse> getStories({
    int page = 1,
    int limit = 10,
    String? category,
    String? region,
    String? language,
    String? search,
    String? sort,
  }) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (category != null) params['category'] = category;
    if (region != null) params['region'] = region;
    if (language != null) params['language'] = language;
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (sort != null) params['sort'] = sort;

    final json = await _client.get(
      ApiConstants.stories,
      queryParameters: params,
    );
    return StoriesResponse.fromJson(json as Map<String, dynamic>);
  }

  /// Fetch a single story by slug.
  Future<StoryDetailResponse> getStoryBySlug(String slug) async {
    final json = await _client.get(ApiConstants.storyBySlug(slug));
    return StoryDetailResponse.fromJson(json as Map<String, dynamic>);
  }
}
