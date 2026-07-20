import '../../features/writer_studio/domain/models/publish_models.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';

class PublishRepository {
  final ApiClient _client;

  PublishRepository(this._client);

  /// Fetch publish review data for a story by its ID.
  Future<PublishReviewResponse> getPublishReview(String storyId) async {
    final json = await _client.get(ApiConstants.publishReviewById(storyId));
    return PublishReviewResponse.fromJson(json as Map<String, dynamic>);
  }

  /// Validate a story for publishing.
  Future<PublishValidation> validate(String storyId) async {
    final json = await _client.post(
      ApiConstants.publishValidate,
      data: {'storyId': storyId},
    );
    return PublishValidation.fromJson(json as Map<String, dynamic>);
  }

  /// Publish (or schedule) a story.
  Future<PublishResult> publish(String storyId, {String? scheduledAt}) async {
    final data = <String, dynamic>{};
    if (scheduledAt != null) data['scheduledAt'] = scheduledAt;

    final json = await _client.post(
      ApiConstants.publishReviewById(storyId),
      data: data.isNotEmpty ? data : null,
    );
    return PublishResult.fromJson(json as Map<String, dynamic>);
  }
}
