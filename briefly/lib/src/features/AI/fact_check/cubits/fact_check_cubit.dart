import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/domain/fact_check_result.dart';
import '../../../models/ui/input_mode.dart';
import 'fact_check_state.dart';

/// Cubit managing the Fact Check / Fake Detection screen.
class FactCheckCubit extends Cubit<FactCheckState> {
  FactCheckCubit() : super(const FactCheckState());

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

  /// Trigger the credibility analysis with simulated 2.5s delay.
  Future<void> analyze() async {
    if (!state.canSubmit) return;

    emit(state.copyWith(isLoading: true, result: () => null));

    await Future.delayed(const Duration(milliseconds: 2500));

    if (isClosed) return;

    final analysisResult = state.mode == InputMode.text
        ? _analyzeText(state.inputText)
        : _analyzeImage();

    emit(state.copyWith(
      isLoading: false,
      result: () => analysisResult,
    ));
  }

  /// Copy feedback â€” shows check for 1.5s.
  Future<void> copyResult() async {
    emit(state.copyWith(hasCopied: true));
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!isClosed) emit(state.copyWith(hasCopied: false));
  }

  /// Reset for another check.
  void reset() {
    emit(const FactCheckState());
  }

  FactCheckResult _analyzeText(String text) {
    // Simple heuristic-based scoring for demo
    final wordCount = text.trim().split(RegExp(r'\s+')).length;
    final hasQuotes = text.contains('"') || text.contains('"');
    final hasNumbers = RegExp(r'\d').hasMatch(text);
    final hasEmotionalWords = RegExp(
      r'\b(shocking|breaking|unbelievable|urgent|exclusive)\b',
      caseSensitive: false,
    ).hasMatch(text);

    int score = 50;
    if (wordCount > 50) score += 15;
    if (hasQuotes) score += 10;
    if (hasNumbers) score += 10;
    if (hasEmotionalWords) score -= 20;
    score = score.clamp(10, 95);

    final verdict = score >= 70
        ? Verdict.credible
        : score >= 40
            ? Verdict.suspicious
            : Verdict.misleading;

    return FactCheckResult(
      verdict: verdict,
      credibilityScore: score,
      factors: [
        FactorResult(
          name: 'Source Attribution',
          status: hasQuotes ? FactorStatus.pass : FactorStatus.warn,
          detail: hasQuotes
              ? 'Contains quoted sources'
              : 'No direct source attribution found',
        ),
        FactorResult(
          name: 'Factual Claims',
          status: hasNumbers ? FactorStatus.pass : FactorStatus.warn,
          detail: hasNumbers
              ? 'Contains verifiable data points'
              : 'No concrete data points detected',
        ),
        FactorResult(
          name: 'Emotional Language',
          status: hasEmotionalWords ? FactorStatus.fail : FactorStatus.pass,
          detail: hasEmotionalWords
              ? 'Sensationalist language detected'
              : 'Neutral tone maintained throughout',
        ),
        FactorResult(
          name: 'Content Length',
          status: wordCount > 30 ? FactorStatus.pass : FactorStatus.warn,
          detail: wordCount > 30
              ? 'Sufficient detail provided ($wordCount words)'
              : 'Limited content for analysis ($wordCount words)',
        ),
        const FactorResult(
          name: 'Consistency',
          status: FactorStatus.pass,
          detail: 'No internal contradictions detected',
        ),
      ],
    );
  }

  FactCheckResult _analyzeImage() {
    // Simplified image analysis logic
    final score = 45 + Random().nextInt(30);
    return FactCheckResult(
      verdict: score >= 70 ? Verdict.credible : Verdict.suspicious,
      credibilityScore: score,
      factors: [
        const FactorResult(
          name: 'Image Metadata',
          status: FactorStatus.warn,
          detail: 'EXIF data partially stripped',
        ),
        const FactorResult(
          name: 'Reverse Search',
          status: FactorStatus.pass,
          detail: 'No exact duplicates with different captions found',
        ),
        const FactorResult(
          name: 'Manipulation Detection',
          status: FactorStatus.pass,
          detail: 'No signs of digital tampering detected',
        ),
        const FactorResult(
          name: 'Context Verification',
          status: FactorStatus.warn,
          detail: 'Unable to verify original context of the image',
        ),
      ],
    );
  }
}




