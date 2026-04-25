import '../../../domain/models/news_article.dart';

class ArticleState {
  final NewsArticle? article;
  final bool isLoading;
  final bool isSummarizing;
  final String? aiSummary;
  final String? error;
  final bool isSaved;
  final bool isReadingAloud;
  final bool isPlaying;
  final int currentParagraphIndex;
  final double playbackSpeed;
  final List<double> availableSpeeds;

  const ArticleState({
    this.article,
    this.isLoading = false,
    this.isSummarizing = false,
    this.aiSummary,
    this.error,
    this.isSaved = false,
    this.isReadingAloud = false,
    this.isPlaying = false,
    this.currentParagraphIndex = 0,
    this.playbackSpeed = 1.0,
    this.availableSpeeds = const [0.5, 0.75, 1.0, 1.25, 1.5, 2.0],
  });

  ArticleState copyWith({
    NewsArticle? article,
    bool? isLoading,
    bool? isSummarizing,
    String? aiSummary,
    String? error,
    bool? clearError,
    bool? isSaved,
    bool? isReadingAloud,
    bool? isPlaying,
    int? currentParagraphIndex,
    double? playbackSpeed,
  }) {
    return ArticleState(
      article: article ?? this.article,
      isLoading: isLoading ?? this.isLoading,
      isSummarizing: isSummarizing ?? this.isSummarizing,
      aiSummary: aiSummary ?? this.aiSummary,
      error: clearError == true ? null : (error ?? this.error),
      isSaved: isSaved ?? this.isSaved,
      isReadingAloud: isReadingAloud ?? this.isReadingAloud,
      isPlaying: isPlaying ?? this.isPlaying,
      currentParagraphIndex:
          currentParagraphIndex ?? this.currentParagraphIndex,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      availableSpeeds: availableSpeeds,
    );
  }
}
