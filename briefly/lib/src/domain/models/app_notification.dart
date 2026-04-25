import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';

enum NotificationType {
  trending,
  ai,
  alert,
  saved,
  system,
}

extension NotificationTypeExtension on NotificationType {
  IconData get icon {
    switch (this) {
      case NotificationType.trending:
        return LucideIcons.trendingUp;
      case NotificationType.ai:
        return LucideIcons.sparkles;
      case NotificationType.alert:
        return LucideIcons.shieldAlert;
      case NotificationType.saved:
        return LucideIcons.bookmark;
      case NotificationType.system:
        return LucideIcons.settings;
    }
  }

  Color get iconColor {
    switch (this) {
      case NotificationType.trending:
        return const Color(0xFFFF5252); // Soft Red
      case NotificationType.ai:
        return AppColors.accentBlue;
      case NotificationType.alert:
        return const Color(0xFFFFC107); // Amber
      case NotificationType.saved:
        return AppColors.success;
      case NotificationType.system:
        return AppColors.primaryAccent;
    }
  }

  Color get backgroundColor {
    return iconColor.withValues(alpha: 0.1);
  }
}

class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isUnread;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isUnread = true,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    // Map Supabase enum types to UI types
    final supabaseType = map['type'] as String?;
    NotificationType uiType;
    
    switch (supabaseType) {
      case 'breaking_news':
        uiType = NotificationType.trending;
        break;
      case 'article':
        uiType = NotificationType.ai;
        break;
      case 'promotion':
        uiType = NotificationType.alert;
        break;
      case 'weekly_digest':
        uiType = NotificationType.saved;
        break;
      case 'system':
      case 'subscription':
      default:
        uiType = NotificationType.system;
    }

    return AppNotification(
      id: map['id'].toString(),
      type: uiType,
      title: map['title'] ?? 'Notification',
      message: map['body'] ?? '',
      timestamp: DateTime.parse(map['created_at']),
      isUnread: !(map['is_read'] ?? true),
    );
  }

  AppNotification copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isUnread,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isUnread: isUnread ?? this.isUnread,
    );
  }
}
