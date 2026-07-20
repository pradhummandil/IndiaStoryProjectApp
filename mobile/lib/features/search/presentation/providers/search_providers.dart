import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/providers.dart';
import '../../domain/models/search_models.dart';

// ── Search Query State ───────────────────────────────────────────────

class SearchQueryState {
  final String query;
  final String? category;
  final String? region;
  final String? sort;
  final int page;

  const SearchQueryState({
    this.query = '',
    this.category,
    this.region,
    this.sort,
    this.page = 1,
  });

  SearchQueryState copyWith({
    String? query,
    String? category,
    String? region,
    String? sort,
    int? page,
  }) {
    return SearchQueryState(
      query: query ?? this.query,
      category: category ?? this.category,
      region: region ?? this.region,
      sort: sort ?? this.sort,
      page: page ?? this.page,
    );
  }
}

final searchQueryProvider =
    StateNotifierProvider<SearchQueryNotifier, SearchQueryState>((ref) {
      return SearchQueryNotifier();
    });

class SearchQueryNotifier extends StateNotifier<SearchQueryState> {
  SearchQueryNotifier() : super(const SearchQueryState());

  void setQuery(String q) => state = state.copyWith(query: q, page: 1);
  void setCategory(String? cat) =>
      state = state.copyWith(category: cat, page: 1);
  void setRegion(String? r) => state = state.copyWith(region: r, page: 1);
  void setSort(String? s) => state = state.copyWith(sort: s, page: 1);
  void setPage(int p) => state = state.copyWith(page: p);
  void reset() => state = const SearchQueryState();
}

// ── Full Search Results Provider ─────────────────────────────────────

final searchResultsProvider = FutureProvider.autoDispose<FullSearchResponse>((
  ref,
) async {
  final q = ref.watch(searchQueryProvider);
  final repo = ref.watch(searchRepositoryProvider);
  return repo.search(
    query: q.query,
    category: q.category,
    region: q.region,
    sort: q.sort,
    page: q.page,
  );
});

// ── Trending Provider ────────────────────────────────────────────────

final trendingSearchesProvider =
    FutureProvider.autoDispose<List<TrendingTopic>>((ref) async {
      final repo = ref.watch(searchRepositoryProvider);
      return repo.getTrending();
    });

// ── Recent Searches Provider ─────────────────────────────────────────

final recentSearchesProvider =
    FutureProvider.autoDispose<List<RecentSearchItem>>((ref) async {
      final repo = ref.watch(searchRepositoryProvider);
      return repo.getRecentSearches();
    });

// ── Suggestions Provider (debounced-like) ────────────────────────────

final suggestionsProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  final q = ref.watch(searchQueryProvider).query;
  if (q.trim().length < 2) return [];
  final repo = ref.watch(searchRepositoryProvider);
  return repo.getSuggestions(q);
});

// ── Clear/Delete Actions ─────────────────────────────────────────────

final clearSearchHistoryProvider = FutureProvider.autoDispose<void>((
  ref,
) async {
  final repo = ref.watch(searchRepositoryProvider);
  await repo.clearSearchHistory();
  ref.invalidate(recentSearchesProvider);
  ref.invalidate(searchResultsProvider);
});

final deleteSearchHistoryItemProvider = FutureProvider.autoDispose
    .family<void, String>((ref, searchId) async {
      final repo = ref.watch(searchRepositoryProvider);
      await repo.deleteSearch(searchId);
      ref.invalidate(recentSearchesProvider);
    });
