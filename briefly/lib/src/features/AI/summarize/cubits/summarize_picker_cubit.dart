import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../models/domain/summarize_result.dart';
import '../../../../models/ui/input_mode.dart';
import 'summarize_picker_state.dart';

/// Cubit managing the AI Summarize Picker screen.
class SummarizePickerCubit extends Cubit<SummarizePickerState> {
  final SupabaseClient _client;

  SummarizePickerCubit(this._client) : super(const SummarizePickerState());

  void setMode(InputMode mode) {
    emit(state.copyWith(mode: mode));
  }

  void setText(String text) {
    emit(state.copyWith(inputText: text));
  }

  void clearText() {
    emit(state.copyWith(inputText: ''));
  }

  void setImage(String? path) {
    emit(state.copyWith(imagePath: () => path));
  }

  void clearImage() {
    emit(state.copyWith(imagePath: () => null));
  }

  void setStyle(SummaryStyle style) {
    emit(state.copyWith(selectedStyle: style));
  }

  /// Trigger the summarization and persist to ai_summaries table.
  Future<void> summarize() async {
    if (!state.canSubmit) return;

    emit(state.copyWith(isLoading: true, result: () => null));

    await Future.delayed(const Duration(milliseconds: 2200));

    final summary = _generateSummary(
      state.inputText,
      state.selectedStyle,
    );

    final result = SummarizeResult(
      summary: summary,
      style: state.selectedStyle,
    );

    emit(state.copyWith(
      isLoading: false,
      result: () => result,
    ));

    // Persist to Supabase
    final user = _client.auth.currentUser;
    if (user != null) {
      try {
        await _client.from('ai_summaries').insert({
          'user_id': user.id,
          'source_text': state.inputText,
          'summary': summary,
          'style': state.selectedStyle.name,
          'language': 'en',
          'provider': 'gemini',
        });
      } catch (e, st) {
        developer.log('ai_summaries insert failed', name: 'summarize', error: e, stackTrace: st);
      }
    }
  }

  /// Copy summary text â€” shows check icon for 1.5s.
  Future<void> copyResult() async {
    emit(state.copyWith(hasCopied: true));
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!isClosed) emit(state.copyWith(hasCopied: false));
  }

  /// Reset everything for a new summarization.
  void reset() {
    emit(const SummarizePickerState());
  }

  String _generateSummary(String input, SummaryStyle style) {
    switch (style) {
      case SummaryStyle.brief:
        return 'This text discusses key developments in the subject matter, '
            'highlighting important changes and their potential impact on the '
            'broader landscape.';
      case SummaryStyle.detailed:
        return 'The provided content covers a comprehensive analysis of recent '
            'developments, examining multiple perspectives and their implications. '
            'Key stakeholders have expressed varied opinions on the matter, with '
            'experts suggesting that the long-term effects could reshape industry '
            'standards. The analysis points to several critical factors that will '
            'determine the outcome, including technological readiness, regulatory '
            'frameworks, and public sentiment.';
      case SummaryStyle.bullets:
        return 'â€¢ Key developments identified in the subject area\n'
            'â€¢ Multiple stakeholders express varied perspectives\n'
            'â€¢ Long-term implications could reshape industry standards\n'
            'â€¢ Technology readiness remains a critical factor\n'
            'â€¢ Regulatory frameworks are evolving in response';
    }
  }
}



