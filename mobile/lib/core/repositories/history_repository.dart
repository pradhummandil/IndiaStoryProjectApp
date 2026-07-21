import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../../features/history/domain/models/history_models.dart';

class HistoryRepository {
  final ApiClient _client;

  HistoryRepository(this._client);

  Future<HistoryResponse> getHistory({
    int page = 1,
    int limit = 20,
    String? filter,
    String? search,
  }) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (filter != null && filter != 'all') params['filter'] = filter;
    if (search != null && search.isNotEmpty) params['search'] = search;

    final json = await _client.get(
      ApiConstants.history,
      queryParameters: params,
    );
    return HistoryResponse.fromJson(json as Map<String, dynamic>);
  }

  Future<void> deleteHistoryItem(String storyId) async {
    await _client.delete(ApiConstants.historyDelete(storyId));
  }

  Future<void> clearHistory() async {
    await _client.delete(ApiConstants.history);
  }
}
