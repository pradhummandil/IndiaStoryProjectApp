import '../../features/writer_studio/domain/models/writer_dashboard_models.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';

class WriterRepository {
  final ApiClient _client;

  WriterRepository(this._client);

  /// Fetches the Writer Studio dashboard data.
  Future<WriterDashboardResponse> getDashboard() async {
    final json = await _client.get(ApiConstants.writerDashboard);
    return WriterDashboardResponse.fromJson(json as Map<String, dynamic>);
  }

  /// Fetches the authenticated writer's stories.
  Future<List<WriterStoryItem>> getWriterStories() async {
    final json = await _client.get(ApiConstants.writerStories);
    final data = json as Map<String, dynamic>;
    final rawItems = data['items'] as List<dynamic>? ?? [];
    return rawItems
        .map((e) => WriterStoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
