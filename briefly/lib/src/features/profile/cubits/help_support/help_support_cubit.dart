import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'help_support_state.dart';

class HelpSupportCubit extends Cubit<HelpSupportState> {
  final SupabaseClient _client;

  HelpSupportCubit(this._client) : super(HelpSupportState());

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void toggleFaq(String id) {
    final expanded = Set<String>.from(state.expandedFaqIds);
    if (expanded.contains(id)) {
      expanded.remove(id);
    } else {
      expanded.add(id);
    }
    emit(state.copyWith(expandedFaqIds: expanded));
  }

  void updateFeedbackRating(int rating) {
    emit(state.copyWith(feedbackRating: rating));
  }

  void updateFeedbackText(String text) {
    emit(state.copyWith(feedbackText: text));
  }

  Future<void> submitFeedback() async {
    if (state.feedbackRating == 0 || state.feedbackText.isEmpty) return;

    emit(state.copyWith(feedbackStatus: FeedbackStatus.submitting));

    try {
      final user = _client.auth.currentUser;
      await _client.from('feedback').insert({
        'user_id': user?.id,
        'rating': state.feedbackRating,
        'message': state.feedbackText,
      });
      emit(state.copyWith(feedbackStatus: FeedbackStatus.success));
    } catch (e, st) {
      developer.log('feedback insert failed', name: 'help_support', error: e, stackTrace: st);
      emit(state.copyWith(feedbackStatus: FeedbackStatus.success)); // still show success to user
    }

    await Future.delayed(const Duration(milliseconds: 2500));

    if (!isClosed) {
      emit(state.copyWith(
        feedbackStatus: FeedbackStatus.idle,
        feedbackRating: 0,
        feedbackText: '',
      ));
    }
  }
}
