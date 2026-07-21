import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/providers.dart';
import '../../../../core/repositories/history_repository.dart';
import '../../domain/models/history_models.dart';

// ── History List State ──────────────────────────────────────────────

class HistoryState {
  final List<HistoryItem> items;
  final int total;
  final int page;
  final int limit;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final String filter; // all, today, week, month
  final String searchQuery;

  const HistoryState({
    this.items = const [],
    this.total = 0,
    this.page = 1,
    this.limit = 20,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.filter = 'all',
    this.searchQuery = '',
  });

  bool get hasMore => items.length < total;

  HistoryState copyWith({
    List<HistoryItem>? items,
    int? total,
    int? page,
    int? limit,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    String? filter,
    String? searchQuery,
  }) {
    return HistoryState(
      items: items ?? this.items,
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class HistoryNotifier extends StateNotifier<HistoryState> {
  final HistoryRepository _repository;

  HistoryNotifier(this._repository) : super(const HistoryState());

  Future<void> loadHistory({String? filter, String? search}) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      page: 1,
      filter: filter ?? state.filter,
      searchQuery: search ?? state.searchQuery,
    );
    try {
      final response = await _repository.getHistory(
        page: 1,
        limit: state.limit,
        filter: filter ?? state.filter,
        search: search ?? state.searchQuery,
      );
      state = state.copyWith(
        items: response.items,
        total: response.total,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.page + 1;
      final response = await _repository.getHistory(
        page: nextPage,
        limit: state.limit,
        filter: state.filter,
        search: state.searchQuery,
      );
      state = state.copyWith(
        items: [...state.items, ...response.items],
        total: response.total,
        page: nextPage,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  Future<void> deleteHistoryItem(String storyId) async {
    final index = state.items.indexWhere((i) => i.storyId == storyId);
    if (index == -1) return;
    final updatedItems = [...state.items];
    updatedItems.removeAt(index);
    state = state.copyWith(items: updatedItems, total: state.total - 1);
    try {
      await _repository.deleteHistoryItem(storyId);
    } catch (e) {
      // Revert not needed for simplicity
    }
  }

  Future<void> clearHistory() async {
    state = state.copyWith(items: [], total: 0);
    try {
      await _repository.clearHistory();
    } catch (e) {
      // Will refresh on next load
    }
  }

  Future<void> refresh() async {
    await loadHistory();
  }

  void setFilter(String filter) {
    if (filter == state.filter) return;
    loadHistory(filter: filter);
  }

  void setSearch(String query) {
    loadHistory(search: query);
  }
}

final historyProvider = StateNotifierProvider<HistoryNotifier, HistoryState>((
  ref,
) {
  final repository = ref.watch(historyRepositoryProvider);
  return HistoryNotifier(repository);
});
