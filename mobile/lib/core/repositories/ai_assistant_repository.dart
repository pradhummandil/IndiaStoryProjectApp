import '../../features/writer_studio/domain/models/ai_assistant_models.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';

class AiAssistantRepository {
  final ApiClient _client;

  AiAssistantRepository(this._client);

  /// Fetch AI assistant context including user profile, story context, and available metadata.
  Future<AiAssistantContext> getContext({String? storyId}) async {
    final params = <String, dynamic>{};
    if (storyId != null) params['storyId'] = storyId;

    final json = await _client.get(
      ApiConstants.aiAssistantContext,
      queryParameters: params.isNotEmpty ? params : null,
    );
    return AiAssistantContext.fromJson(json as Map<String, dynamic>);
  }

  /// Send a chat message to the AI assistant.
  Future<AiChatResponse> chat({
    required String storyId,
    required String message,
    List<Map<String, dynamic>> history = const [],
  }) async {
    final json = await _client.post(
      ApiConstants.aiAssistantChat,
      data: {'storyId': storyId, 'message': message, 'history': history},
    );
    return AiChatResponse.fromJson(json as Map<String, dynamic>);
  }

  /// Rewrite content with specified tone.
  Future<RewriteResponse> rewrite({
    required String storyId,
    required String content,
    String tone = 'editorial',
  }) async {
    final json = await _client.post(
      ApiConstants.aiAssistantRewrite,
      data: {'storyId': storyId, 'content': content, 'tone': tone},
    );
    return RewriteResponse.fromJson(json as Map<String, dynamic>);
  }

  /// Get SEO suggestions for a story.
  Future<SeoSuggestionResponse> getSeoSuggestions({
    required String storyId,
  }) async {
    final json = await _client.post(
      ApiConstants.aiAssistantSeo,
      data: {'storyId': storyId},
    );
    return SeoSuggestionResponse.fromJson(json as Map<String, dynamic>);
  }

  /// Generate title suggestions for a story.
  Future<TitleSuggestionResponse> getTitleSuggestions({
    required String storyId,
  }) async {
    final json = await _client.post(
      ApiConstants.aiAssistantTitle,
      data: {'storyId': storyId},
    );
    return TitleSuggestionResponse.fromJson(json as Map<String, dynamic>);
  }

  /// Generate an outline for a story.
  Future<OutlineResponse> getOutline({required String storyId}) async {
    final json = await _client.post(
      ApiConstants.aiAssistantOutline,
      data: {'storyId': storyId},
    );
    return OutlineResponse.fromJson(json as Map<String, dynamic>);
  }

  /// Generate a summary for story content.
  Future<SummaryResponse> getSummary({
    required String storyId,
    required String content,
    String length = 'medium',
  }) async {
    final json = await _client.post(
      ApiConstants.aiAssistantSummary,
      data: {'storyId': storyId, 'content': content, 'length': length},
    );
    return SummaryResponse.fromJson(json as Map<String, dynamic>);
  }
}
