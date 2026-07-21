import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/providers.dart';
import '../../domain/models/notification_models.dart';

// ── Notification List State ──────────────────────────────────────────

class NotificationsState {
  final List<NotificationItem> items;
  final int total;
  final int page;
  final int limit;
  final int unreadCount;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final String selectedTab; // 'all', 'activity', 'system'

  const NotificationsState({
    this.items = const [],
    this.total = 0,
    this.page = 1,
    this.limit = 20,
    this.unreadCount = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.selectedTab = 'all',
  });

  bool get hasMore => items.length < total;

  NotificationsState copyWith({
    List<NotificationItem>? items,
    int? total,
    int? page,
    int? limit,
    int? unreadCount,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    String? selectedTab,
  }) {
    return NotificationsState(
      items: items ?? this.items,
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsNotifier(this._repository) : super(const NotificationsState());

  /// Load initial notifications.
  Future<void> loadNotifications({String? type}) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      page: 1,
      selectedTab: type ?? 'all',
    );
    try {
      final response = await _repository.getNotifications(
        page: 1,
        limit: state.limit,
        type: type ?? state.selectedTab,
      );
      state = state.copyWith(
        items: response.items,
        total: response.total,
        unreadCount: response.unreadCount,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Load more (pagination).
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.page + 1;
      final response = await _repository.getNotifications(
        page: nextPage,
        limit: state.limit,
        type: state.selectedTab,
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

  /// Mark a single notification as read (optimistic).
  Future<void> markAsRead(String notificationId) async {
    final index = state.items.indexWhere((n) => n.id == notificationId);
    if (index == -1) return;
    final item = state.items[index];
    if (item.isRead) return;

    // Optimistic update
    final updatedItems = [...state.items];
    updatedItems[index] = item.copyWith(isRead: true);
    state = state.copyWith(
      items: updatedItems,
      unreadCount: state.unreadCount - 1,
    );

    try {
      await _repository.markAsRead(notificationId);
    } catch (e) {
      // Revert on error
      updatedItems[index] = item;
      state = state.copyWith(
        items: updatedItems,
        unreadCount: state.unreadCount + 1,
      );
    }
  }

  /// Mark all as read.
  Future<void> markAllAsRead() async {
    final previousItems = List<NotificationItem>.from(state.items);
    state = state.copyWith(
      items: state.items.map((n) => n.copyWith(isRead: true)).toList(),
      unreadCount: 0,
    );
    try {
      await _repository.markAllAsRead();
    } catch (e) {
      state = state.copyWith(
        items: previousItems,
        unreadCount: state.unreadCount,
      );
    }
  }

  /// Delete a notification (optimistic).
  Future<void> deleteNotification(String notificationId) async {
    final index = state.items.indexWhere((n) => n.id == notificationId);
    if (index == -1) return;
    final item = state.items[index];
    final updatedItems = [...state.items];
    updatedItems.removeAt(index);

    state = state.copyWith(
      items: updatedItems,
      total: state.total - 1,
      unreadCount: item.isRead ? state.unreadCount : state.unreadCount - 1,
    );

    try {
      await _repository.deleteNotification(notificationId);
    } catch (e) {
      // Revert
      updatedItems.insert(index, item);
      state = state.copyWith(
        items: updatedItems,
        total: state.total + 1,
        unreadCount: item.isRead ? state.unreadCount : state.unreadCount + 1,
      );
    }
  }

  /// Refresh (pull to refresh).
  Future<void> refresh() async {
    await loadNotifications(type: state.selectedTab);
  }

  /// Switch tab.
  void switchTab(String tab) {
    if (tab == state.selectedTab) return;
    loadNotifications(type: tab);
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
      final repository = ref.watch(notificationsRepositoryProvider);
      return NotificationsNotifier(repository);
    });

// ── Unread Count Provider ────────────────────────────────────────────

final unreadCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(notificationsRepositoryProvider);
  return repository.getUnreadCount();
});
