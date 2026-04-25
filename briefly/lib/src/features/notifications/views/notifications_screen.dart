import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../cubits/notifications_cubit.dart';
import '../cubits/notifications_state.dart';
import '../widget/notifications/notification_card.dart';
import '../widget/notifications/notifications_empty_state.dart';
import '../widget/notifications/notifications_top_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoaded) {
              return Stack(
                children: [
                  // Scrollable Notifications List
                  Positioned.fill(
                    child: ListView(
                      padding: const EdgeInsets.only(
                        top: 120, // Padding for floating top bar
                        bottom: 40,
                        left: 20,
                        right: 20,
                      ),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        if (state.notifications.isEmpty)
                          const NotificationsEmptyState()
                        else ...[
                          if (state.newNotifications.isNotEmpty) ...[
                            _buildSectionLabel(
                                'NEW (${state.newNotifications.length})',
                                topPadding: 0),
                            ...state.newNotifications.map(
                              (notification) => NotificationCard(
                                notification: notification,
                                onTap: () {
                                  context
                                      .read<NotificationsCubit>()
                                      .markAsRead(notification.id);
                                },
                              ),
                            ),
                          ],
                          if (state.earlierNotifications.isNotEmpty) ...[
                            _buildSectionLabel('EARLIER', topPadding: 24), // pt-6
                            ...state.earlierNotifications.map(
                              (notification) => NotificationCard(
                                notification: notification,
                                onTap: null, // Non-interactive
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),

                  // Floating Top Bar
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: NotificationsTopBar(
                      unreadCount: state.unreadCount,
                      onMarkAllRead: () {
                        context.read<NotificationsCubit>().markAllAsRead();
                      },
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
    );
  }

  Widget _buildSectionLabel(String text, {required double topPadding}) {
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: 12, // mb-3
        left: 4, // px-1
        right: 4,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 2.0, // Tracking 0.2em roughly
          color: AppColors.mutedForeground,
        ),
      ),
    );
  }
}


