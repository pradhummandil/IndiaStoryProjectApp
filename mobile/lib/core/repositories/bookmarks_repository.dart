import '../network/api_client.dart';
import '../../features/saved_stories/domain/models/saved_story_models.dart';

class BookmarksRepository {
  final ApiClient _client;

  BookmarksRepository(this._client);

  Future<BookmarksResponse> getBookmarks({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
  }) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (category != null && category.isNotEmpty) params['category'] = category;

    final json = await _client.get('/api/bookmarks', queryParameters: params);
    return BookmarksResponse.fromJson(json as Map<String, dynamic>);
  }

  Future<BookmarkActionResponse> addBookmark(String storyId) async {
    final json = await _client.post('/api/bookmarks/$storyId');
    return BookmarkActionResponse.fromJson(json as Map<String, dynamic>);
  }

  Future<BookmarkActionResponse> removeBookmark(String storyId) async {
    final json = await _client.delete('/api/bookmarks/$storyId');
    return BookmarkActionResponse.fromJson(json as Map<String, dynamic>);
  }
}
