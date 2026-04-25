import 'package:flutter_bloc/flutter_bloc.dart';
import 'help_support_state.dart';

class HelpSupportCubit extends Cubit<HelpSupportState> {
  HelpSupportCubit() : super(HelpSupportState());

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
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    emit(state.copyWith(feedbackStatus: FeedbackStatus.success));
    
    // Auto reset after 2500ms
    await Future.delayed(const Duration(milliseconds: 2500));
    
    emit(state.copyWith(
      feedbackStatus: FeedbackStatus.idle,
      feedbackRating: 0,
      feedbackText: '',
    ));
  }
}
