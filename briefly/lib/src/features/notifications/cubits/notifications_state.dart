import 'package:equatable/equatable.dart';
import '../../../domain/models/app_notification.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<AppNotification> notifications;

  const NotificationsLoaded({required this.notifications});

  @override
  List<Object> get props => [notifications];

  int get unreadCount => notifications.where((n) => n.isUnread).length;

  List<AppNotification> get newNotifications =>
      notifications.where((n) => n.isUnread).toList();

  List<AppNotification> get earlierNotifications =>
      notifications.where((n) => !n.isUnread).toList();
}




