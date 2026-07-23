import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/app_colors.dart';
import '../../domain/models/notification_models.dart';
import '../providers/notifications_providers.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsProvider.notifier).loadNotifications();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(notificationsProvider.notifier).loadMore();
    }
  }

  void _onTabChanged(String tab) {
    ref.read(notificationsProvider.notifier).switchTab(tab);
  }

  void _onRefresh() {
    ref.read(notificationsProvider.notifier).refresh();
  }

  void _onNotificationTap(NotificationItem notification) {
    if (!notification.isRead) {
      ref.read(notificationsProvider.notifier).markAsRead(notification.id);
    }
  }

  void _onDelete(NotificationItem notification) {
    ref
        .read(notificationsProvider.notifier)
        .deleteNotification(notification.id);
  }

  void _onMarkAllAsRead() {
    ref.read(notificationsProvider.notifier).markAllAsRead();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final state = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F3),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopAppBar(
              colors: colors,
              unreadCount: state.unreadCount,
              onMarkAllAsRead: state.unreadCount > 0 ? _onMarkAllAsRead : null,
            ),
            _Tabs(
              selectedTab: state.selectedTab,
              onTabChanged: _onTabChanged,
              colors: colors,
            ),
            Expanded(child: _buildContent(state, colors)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(NotificationsState state, AppColors colors) {
    if (state.isLoading && state.items.isEmpty) {
      return const _LoadingState();
    }
    if (state.error != null && state.items.isEmpty) {
      return _ErrorState(
        message: state.error!,
        onRetry: _onRefresh,
        colors: colors,
      );
    }
    if (state.items.isEmpty) {
      return _EmptyState(colors: colors);
    }
    return RefreshIndicator(
      onRefresh: () async => _onRefresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 32),
        itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.items.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          final notification = state.items[index];
          final isFirstInGroup =
              index == 0 ||
              _getGroupLabel(state.items[index - 1].createdAt) !=
                  _getGroupLabel(notification.createdAt);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isFirstInGroup)
                _GroupLabel(
                  label: _getGroupLabel(notification.createdAt),
                  colors: colors,
                ),
              _NotificationItem(
                notification: notification,
                colors: colors,
                onTap: () => _onNotificationTap(notification),
                onDelete: () => _onDelete(notification),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getGroupLabel(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return 'Earlier this week';
    if (diff.inDays < 14) return 'Last week';
    return 'Earlier';
  }
}

class _TopAppBar extends StatelessWidget {
  final AppColors colors;
  final int unreadCount;
  final VoidCallback? onMarkAllAsRead;
  const _TopAppBar({
    required this.colors,
    required this.unreadCount,
    this.onMarkAllAsRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFFCF9F3),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFDFBFBC).withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_rounded,
                color: colors.primary,
                size: 24,
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Notifications',
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: colors.primary,
              letterSpacing: -0.02,
              height: 32 / 24,
            ),
          ),
          const Spacer(),
          if (onMarkAllAsRead != null)
            InkWell(
              onTap: onMarkAllAsRead,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  'Mark all read',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colors.primary,
                    letterSpacing: 0.05,
                    height: 16 / 12,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  final String selectedTab;
  final ValueChanged<String> onTabChanged;
  final AppColors colors;
  const _Tabs({
    required this.selectedTab,
    required this.onTabChanged,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['all', 'activity', 'system'];
    final labels = ['All', 'Activity', 'System'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFDFBFBC).withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = tabs[index] == selectedTab;
          return Expanded(
            child: InkWell(
              onTap: () => onTabChanged(tabs[index]),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? colors.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  labels[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.05,
                    color: isSelected ? colors.primary : colors.secondary,
                    height: 16 / 12,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  final String label;
  final AppColors colors;
  const _GroupLabel({required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
          color: colors.secondary,
          height: 16 / 12,
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationItem notification;
  final AppColors colors;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  const _NotificationItem({
    required this.notification,
    required this.colors,
    required this.onTap,
    required this.onDelete,
  });

  IconData _iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.newStory:
        return Icons.menu_book_rounded;
      case NotificationType.bookmarkReminder:
        return Icons.bookmark_rounded;
      case NotificationType.readingClub:
        return Icons.forum_rounded;
      case NotificationType.community:
        return Icons.groups_rounded;
      case NotificationType.writerUpdate:
        return Icons.edit_note_rounded;
      case NotificationType.adminMessage:
        return Icons.admin_panel_settings_rounded;
      case NotificationType.achievement:
        return Icons.workspace_premium_rounded;
      case NotificationType.challenge:
        return Icons.emoji_events_rounded;
      case NotificationType.system:
        return Icons.update_rounded;
    }
  }

  Color _iconBgColor(NotificationType type) {
    switch (type) {
      case NotificationType.newStory:
        return const Color(0xFF8B1E1E);
      case NotificationType.achievement:
        return const Color(0xFFCCA730);
      case NotificationType.system:
        return const Color(0xFFE6DED9);
      case NotificationType.community:
      case NotificationType.readingClub:
        return const Color(0xFFE5E2DC);
      case NotificationType.writerUpdate:
        return const Color(0xFF635D5A);
      case NotificationType.adminMessage:
        return const Color(0xFF6A020A);
      case NotificationType.bookmarkReminder:
        return const Color(0xFF735C00);
      case NotificationType.challenge:
        return const Color(0xFFBA1A1A);
    }
  }

  Color _iconColor(NotificationType type) {
    switch (type) {
      case NotificationType.newStory:
        return Colors.white;
      case NotificationType.achievement:
        return const Color(0xFF4F3D00);
      case NotificationType.system:
        return const Color(0xFF67625E);
      case NotificationType.community:
      case NotificationType.readingClub:
        return const Color(0xFF58413F);
      case NotificationType.writerUpdate:
      case NotificationType.adminMessage:
      case NotificationType.bookmarkReminder:
      case NotificationType.challenge:
        return Colors.white;
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.month}/${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: colors.error,
        child: Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUnread ? const Color(0xCCFFFFFF) : Colors.transparent,
            border: Border.all(
              color: isUnread ? const Color(0x4DDFBFBC) : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isUnread
                ? [
                    BoxShadow(
                      color: const Color(0x0D2D2926),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _iconBgColor(notification.type),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _iconForType(notification.type),
                  size: 24,
                  color: _iconColor(notification.type),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: const TextStyle(
                              fontFamily: 'EB Garamond',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1C1C18),
                              height: 20 / 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTime(notification.createdAt),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colors.secondary,
                            height: 16 / 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: colors.secondary,
                        height: 20 / 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (isUnread)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(left: 4, top: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B1E1E),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFE5E2DC),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E2DC),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EEE8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final AppColors colors;
  const _ErrorState({
    required this.message,
    required this.onRetry,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 48, color: colors.error),
            const SizedBox(height: 16),
            Text(
              'Could not load notifications',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colors.onBackground,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppColors colors;
  const _EmptyState({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF0EEE8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 40,
                color: const Color(0xFF8B716E).withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: TextStyle(
                fontFamily: 'EB Garamond',
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: colors.onBackground,
                height: 32 / 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "When you receive notifications, they'll appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: colors.onSurfaceVariant,
                height: 20 / 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
