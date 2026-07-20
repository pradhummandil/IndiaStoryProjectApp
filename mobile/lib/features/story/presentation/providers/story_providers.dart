import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/story.dart';
import '../../../../core/network/providers.dart';

/// Fetches story detail by slug from the backend API.
final storyDetailProvider = FutureProvider.family<StoryDetailResponse, String>((
  ref,
  slug,
) async {
  final repo = ref.watch(storyRepositoryProvider);
  return repo.getStoryBySlug(slug);
});
