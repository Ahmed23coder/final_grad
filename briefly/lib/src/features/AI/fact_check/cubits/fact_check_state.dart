i wAimport 'package:equatable/equatable.dart';

import '../../../models/domain/fact_check_result.dart';
import '../../../models/ui/input_mode.dart';

/// State for the Fact Check screen.
class FactCheckState extends Equatable {
  final InputMode mode;
  final String inputText;
  final String? imagePath;
  final bool isLoading;
  final FactCheckResult? result;
  final bool hasCopied;

  const FactCheckState({
    this.mode = InputMode.text,
    this.inputText = '',
    this.imagePath,
    this.isLoading = false,
    this.result,
    this.hasCopied = false,
  });

  /// Whether the analyze button should be enabled.
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

  FactCheckState copyWith({
    InputMode? mode,
    String? inputText,
    String? Function()? imagePath,
    bool? isLoading,
    FactCheckResult? Function()? result,
    bool? hasCopied,
  }) {
    return FactCheckState(
      mode: mode ?? this.mode,
      inputText: inputText ?? this.inputText,
      imagePath: imagePath != null ? imagePath() : this.imagePath,
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
        isLoading,
        result,
        hasCopied,
      ];
}




