import 'package:flutter_bloc/flutter_bloc.dart';

import 'summarize_detail_state.dart';

/// Cubit for the article-bound AI Summarize Detail screen.
class SummarizeDetailCubit extends Cubit<SummarizeDetailState> {
  SummarizeDetailCubit({required String articleId})
      : super(SummarizeDetailState(articleId: articleId)) {
    _loadArticleAndAnalyze();
  }

  Future<void> _loadArticleAndAnalyze() async {
    // Simulate loading article + AI analysis (1.5s)
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(milliseconds: 1500));

    if (isClosed) return;

    emit(state.copyWith(
      isLoading: false,
      articleTitle: 'The AI Revolution Is Reshaping Global Markets',
      articleSource: 'Reuters',
      articleCategory: 'TECHNOLOGY',
      summaryText:
          'Artificial intelligence is rapidly transforming global markets, with '
          'major tech companies investing billions in AI infrastructure. The shift '
          'is creating new opportunities while disrupting traditional industries. '
          'Experts predict that AI-driven automation will reshape the workforce '
          'within the next decade, requiring significant policy adaptations and '
          'workforce retraining programs worldwide.',
      keyPoints: [
        'AI investment by major tech companies has exceeded \$200 billion globally in the past year.',
        'Traditional industries face significant disruption from AI-driven automation.',
        'Workforce retraining programs are becoming a policy priority for governments.',
        'New regulatory frameworks are emerging to address AI safety and ethical concerns.',
        'Small and medium businesses are increasingly adopting AI tools for competitive advantage.',
      ],
      analysisMetrics: {
        'Sentiment': 'Neutral-Positive',
        'Read Time': '4 min',
        'Complexity': 'Moderate',
        'Source Reliability': 'High',
        'Bias Indicator': 'Low',
      },
    ));
  }

  void setTab(SummarizeDetailTab tab) {
    emit(state.copyWith(activeTab: tab));
  }

  /// Copy feedback — shows check for 1.5s.
  Future<void> copyResult() async {
    emit(state.copyWith(hasCopied: true));
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!isClosed) emit(state.copyWith(hasCopied: false));
  }
}
