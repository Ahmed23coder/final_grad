import 'package:equatable/equatable.dart';

/// Active tab on the summarize detail screen.
enum SummarizeDetailTab { summary, keyPoints, analysis }

/// State for the AI Summarize Detail screen (/summarize/:id).
class SummarizeDetailState extends Equatable {
  final String articleId;
  final String articleTitle;
  final String articleSource;
  final String articleCategory;
  final SummarizeDetailTab activeTab;
  final bool isLoading;
  final String summaryText;
  final List<String> keyPoints;
  final Map<String, String> analysisMetrics;
  final bool hasCopied;

  const SummarizeDetailState({
    required this.articleId,
    this.articleTitle = '',
    this.articleSource = '',
    this.articleCategory = '',
    this.activeTab = SummarizeDetailTab.summary,
    this.isLoading = true,
    this.summaryText = '',
    this.keyPoints = const [],
    this.analysisMetrics = const {},
    this.hasCopied = false,
  });

  SummarizeDetailState copyWith({
    String? articleId,
    String? articleTitle,
    String? articleSource,
    String? articleCategory,
    SummarizeDetailTab? activeTab,
    bool? isLoading,
    String? summaryText,
    List<String>? keyPoints,
    Map<String, String>? analysisMetrics,
    bool? hasCopied,
  }) {
    return SummarizeDetailState(
      articleId: articleId ?? this.articleId,
      articleTitle: articleTitle ?? this.articleTitle,
      articleSource: articleSource ?? this.articleSource,
      articleCategory: articleCategory ?? this.articleCategory,
      activeTab: activeTab ?? this.activeTab,
      isLoading: isLoading ?? this.isLoading,
      summaryText: summaryText ?? this.summaryText,
      keyPoints: keyPoints ?? this.keyPoints,
      analysisMetrics: analysisMetrics ?? this.analysisMetrics,
      hasCopied: hasCopied ?? this.hasCopied,
    );
  }

  @override
  List<Object?> get props => [
        articleId,
        articleTitle,
        articleSource,
        articleCategory,
        activeTab,
        isLoading,
        summaryText,
        keyPoints,
        analysisMetrics,
        hasCopied,
      ];
}
