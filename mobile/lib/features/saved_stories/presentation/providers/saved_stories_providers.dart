import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/providers.dart';
import '../../domain/models/saved_story_models.dart';

/// Provider that fetches all bookmarked stories for the saved stories screen.
final savedStoriesProvider = FutureProvider<BookmarksResponse>((ref) async {
  final repo = ref.watch(bookmarksRepositoryProvider);
  return repo.getBookmarks();
});

/// Provider to remove a bookmark.
final removeBookmarkProvider =
    FutureProvider.family<BookmarkActionResponse, String>((ref, storyId) async {
      final repo = ref.watch(bookmarksRepositoryProvider);
      return repo.removeBookmark(storyId);
    });
