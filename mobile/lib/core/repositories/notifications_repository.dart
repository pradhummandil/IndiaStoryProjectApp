import '../../features/notifications/domain/models/notification_models.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';

class NotificationsRepository {
  final ApiClient _client;

  NotificationsRepository(this._client);

  /// Fetch paginated notifications.
  Future<NotificationsResponse> getNotifications({
    int page = 1,
    int limit = 20,
    String? type,
  }) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (type != null && type != 'all') params['type'] = type;

    final json = await _client.get(
      ApiConstants.notifications,
      queryParameters: params,
    );
    return NotificationsResponse.fromJson(json as Map<String, dynamic>);
  }

  /// Mark a single notification as read.
  Future<void> markAsRead(String notificationId) async {
    await _client.patch(ApiConstants.notificationRead(notificationId));
  }

  /// Mark all notifications as read.
  Future<void> markAllAsRead() async {
    await _client.patch(ApiConstants.notificationReadAll);
  }

  /// Delete a single notification.
  Future<void> deleteNotification(String notificationId) async {
    await _client.delete(ApiConstants.notificationDelete(notificationId));
  }

  /// Get unread count.
  Future<int> getUnreadCount() async {
    final json = await _client.get(ApiConstants.notificationUnreadCount);
    return (json as Map<String, dynamic>)['count'] as int? ?? 0;
  }
}
