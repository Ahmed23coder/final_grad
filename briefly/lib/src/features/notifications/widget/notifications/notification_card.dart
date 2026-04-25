import 'package:flutter/material.dart';
import '../../../../domain/models/app_notification.dart';
import '../../../../core/theme/app_colors.dart';


class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (notification.isUnread) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            highlightColor: Colors.white.withValues(alpha: 0.08),
            splashColor: Colors.white.withValues(alpha: 0.08),
            child: Ink(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.10),
                ),
              ),
              child: _buildContent(context, true),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.borderColor.withValues(alpha: 0.5),
            ),
          ),
          child: _buildContent(context, false),
        ),
      );
    }
  }

  Widget _buildContent(BuildContext context, bool isUnread) {
    final contentOpacity = isUnread ? 1.0 : 0.60;
    
    return Opacity(
      opacity: contentOpacity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Circle
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnread 
                ? notification.type.backgroundColor.withValues(alpha: 1.0) // 100% opacity of the colored background color (which itself is 10% or similar) Wait, the spec says "Type-colored background (100% opacity)" meaning the predefined 10% color should be fully opaque as defined.
                : notification.type.backgroundColor.withValues(alpha: 0.5), // 50% opacity definition of that color? Or 50% opacity widget?
            ),
            alignment: Alignment.center,
            child: Opacity(
              opacity: isUnread ? 1.0 : 0.60,
              child: Icon(
                notification.type.icon,
                color: notification.type.iconColor,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (isUnread) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.blue[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 6), // roughly space-y-2.5 
                // Message
                Text(
                  notification.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    height: 1.5,
                    color: Color(0xFFB0C4DE),
                  ),
                ),
                const SizedBox(height: 6), // mt-1.5
                // Timestamp
                Text(
                  _formatTimeAgo(notification.timestamp),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


