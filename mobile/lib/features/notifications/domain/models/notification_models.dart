// ── Notification Type ────────────────────────────────────────────────

enum NotificationType {
  newStory,
  bookmarkReminder,
  readingClub,
  community,
  writerUpdate,
  adminMessage,
  achievement,
  challenge,
  system;

  static NotificationType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'NEW_STORY':
        return NotificationType.newStory;
      case 'BOOKMARK_REMINDER':
        return NotificationType.bookmarkReminder;
      case 'READING_CLUB':
        return NotificationType.readingClub;
      case 'COMMUNITY':
        return NotificationType.community;
      case 'WRITER_UPDATE':
        return NotificationType.writerUpdate;
      case 'ADMIN_MESSAGE':
        return NotificationType.adminMessage;
      case 'ACHIEVEMENT':
        return NotificationType.achievement;
      case 'CHALLENGE':
        return NotificationType.challenge;
      default:
        return NotificationType.system;
    }
  }

  String toJson() => name;
}

// ── Notification Item ────────────────────────────────────────────────

class NotificationItem {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NotificationItem({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    this.isRead = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: NotificationType.fromString(json['type'] as String? ?? 'SYSTEM'),
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      userId: userId,
      type: type,
      title: title,
      message: message,
      data: data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// ── Notifications Response ───────────────────────────────────────────

class NotificationsResponse {
  final List<NotificationItem> items;
  final int total;
  final int page;
  final int limit;
  final int unreadCount;

  const NotificationsResponse({
    this.items = const [],
    this.total = 0,
    this.page = 1,
    this.limit = 20,
    this.unreadCount = 0,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return NotificationsResponse(
      items: rawItems
          .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
    );
  }
}
