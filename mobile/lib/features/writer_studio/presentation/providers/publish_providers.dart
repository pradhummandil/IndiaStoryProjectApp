import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/providers.dart';
import '../../domain/models/publish_models.dart';

/// Provider for publish review data.
final publishReviewProvider =
    FutureProvider.family<PublishReviewResponse, String>((ref, storyId) async {
      final repo = ref.watch(publishRepositoryProvider);
      return repo.getPublishReview(storyId);
    });

/// Provider for publishing validation.
final publishValidationProvider =
    FutureProvider.family<PublishValidation, String>((ref, storyId) async {
      final repo = ref.watch(publishRepositoryProvider);
      return repo.validate(storyId);
    });

/// Provider for publishing a story.
final publishActionProvider =
    FutureProvider.family<PublishResult, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final repo = ref.watch(publishRepositoryProvider);
      return repo.publish(
        params['storyId'] as String,
        scheduledAt: params['scheduledAt'] as String?,
      );
    });
