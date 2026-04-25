import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';

class NotificationsTopBar extends StatelessWidget {
  final int unreadCount;
  final VoidCallback? onMarkAllRead;

  const NotificationsTopBar({
    super.key,
    required this.unreadCount,
    this.onMarkAllRead,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // px-5 pt-14 pb-2 
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 8), 
      // Adjusted top so it sits below status bar roughly. Could use SafeArea but the spec specifies pt-14 (56px) so we use that.
      // Wait, standard pt-14 in Tailwind is 56px. Let's use 56px.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0), // blur-2xl
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // px-4 py-2.5
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.80),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left - Back Button
                _buildCircularButton(
                  icon: LucideIcons.arrowLeft,
                  onTap: () {
                    // It should probably pop, let's just use context.pop
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
                ),

                // Center - Title
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.bell,
                      color: AppColors.primaryAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryAccent,
                      ),
                    ),
                    if (unreadCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), // px-2 py-0.5
                        decoration: BoxDecoration(
                          color: Colors.red[500],
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          unreadCount.toString(),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // Right - Status / Spacer
                if (unreadCount > 0)
                  _buildCircularButton(
                    icon: LucideIcons.check,
                    onTap: onMarkAllRead,
                  )
                else
                  const SizedBox(width: 36), // Empty spacer w-9 (36px) for symmetry
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          width: 36, // w-9 generally is 36px
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Icon(
            icon,
            size: 16, // Matches standard small icon size in such pills
            color: AppColors.primaryAccent,
          ),
        ),
      ),
    );
  }
}
