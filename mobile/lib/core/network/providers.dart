import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import '../repositories/home_repository.dart';
import '../repositories/story_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/profile_repository.dart';

// ── API Client ───────────────────────────────────────────────────────

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// ── Repositories ─────────────────────────────────────────────────────

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(ref.watch(apiClientProvider));
});

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  return StoryRepository(ref.watch(apiClientProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.watch(apiClientProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(apiClientProvider));
});
