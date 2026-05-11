import 'package:equatable/equatable.dart';

import '../../../../models/domain/summarize_result.dart';
import '../../../../models/ui/input_mode.dart';

/// State for the AI Summarize Picker screen.
class SummarizePickerState extends Equatable {
  final InputMode mode;
  final String inputText;
  final String? imagePath;
  final SummaryStyle selectedStyle;
  final bool isLoading;
  final SummarizeResult? result;
  final bool hasCopied;

  const SummarizePickerState({
    this.mode = InputMode.text,
    this.inputText = '',
    this.imagePath,
    this.selectedStyle = SummaryStyle.brief,
    this.isLoading = false,
    this.result,
    this.hasCopied = false,
  });

  /// Whether the CTA button should be enabled.
  bool get canSubmit {
    if (isLoading) return false;
    if (mode == InputMode.text) return inputText.trim().length >= 20;
    return imagePath != null;
  }

  /// Word count for the text input.
  int get wordCount {
    final trimmed = inputText.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r'\s+')).length;
  }

  SummarizePickerState copyWith({
    InputMode? mode,
    String? inputText,
    String? Function()? imagePath,
    SummaryStyle? selectedStyle,
    bool? isLoading,
    SummarizeResult? Function()? result,
    bool? hasCopied,
  }) {
    return SummarizePickerState(
      mode: mode ?? this.mode,
      inputText: inputText ?? this.inputText,
      imagePath: imagePath != null ? imagePath() : this.imagePath,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      isLoading: isLoading ?? this.isLoading,
      result: result != null ? result() : this.result,
      hasCopied: hasCopied ?? this.hasCopied,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        inputText,
        imagePath,
        selectedStyle,
        isLoading,
        result,
        hasCopied,
      ];
}



