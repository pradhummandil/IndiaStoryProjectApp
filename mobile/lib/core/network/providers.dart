import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import '../repositories/home_repository.dart';
import '../repositories/story_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/writer_repository.dart';
import '../repositories/ai_assistant_repository.dart';
import '../repositories/publish_repository.dart';
import '../repositories/bookmarks_repository.dart';
import '../repositories/search_repository.dart';
import '../repositories/notifications_repository.dart';
import '../repositories/history_repository.dart';

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

final writerRepositoryProvider = Provider<WriterRepository>((ref) {
  return WriterRepository(ref.watch(apiClientProvider));
});

final aiAssistantRepositoryProvider = Provider<AiAssistantRepository>((ref) {
  return AiAssistantRepository(ref.watch(apiClientProvider));
});

final publishRepositoryProvider = Provider<PublishRepository>((ref) {
  return PublishRepository(ref.watch(apiClientProvider));
});

final bookmarksRepositoryProvider = Provider<BookmarksRepository>((ref) {
  return BookmarksRepository(ref.watch(apiClientProvider));
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(ref.watch(apiClientProvider));
});

final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  return NotificationsRepository(ref.watch(apiClientProvider));
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(ref.watch(apiClientProvider));
});
