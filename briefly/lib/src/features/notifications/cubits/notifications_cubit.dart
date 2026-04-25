import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/app_notification.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final _supabase = Supabase.instance.client;
  StreamSubscription? _subscription;

  NotificationsCubit() : super(NotificationsInitial()) {
    _loadInitialNotifications();
    _setupRealtimeSubscription();
  }

  Future<void> _loadInitialNotifications() async {
    emit(NotificationsLoading());

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        emit(const NotificationsLoaded(notifications: []));
        return;
      }

      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      final notifications = (response as List)
          .map((item) => AppNotification.fromMap(item as Map<String, dynamic>))
          .toList();

      emit(NotificationsLoaded(notifications: notifications));
    } catch (e) {
      emit(const NotificationsLoaded(notifications: []));
    }
  }

  void _setupRealtimeSubscription() {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    _subscription = _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .listen((data) {
          final notifications = data
              .map((item) => AppNotification.fromMap(item))
              .toList();
          emit(NotificationsLoaded(notifications: notifications));
        });
  }

  Future<void> markAsRead(String id) async {
    if (state is NotificationsLoaded) {
      try {
        await _supabase
            .from('notifications')
            .update({'is_read': true})
            .eq('id', id);
        
        // No need to manually emit here as the stream will pick up the change
      } catch (e) {
        // Handle error
      }
    }
  }

  Future<void> markAllAsRead() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', user.id)
          .eq('is_read', false);
      
      // No need to manually emit here as the stream will pick up the change
    } catch (e) {
      // Handle error
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
