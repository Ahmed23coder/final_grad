import '../../../../domain/models/hot_topic_filter.dart';
import '../../../../domain/models/news_article.dart';

class HotTopicsState {
  final bool isLoading;
  final String? error;
  final HotTopicFilter activeFilter;
  final List<NewsArticle> allHotTopics;
  final List<NewsArticle> filteredHotTopics;
  final bool isFiltersVisible;

  const HotTopicsState({
    this.isLoading = false,
    this.error,
    this.activeFilter = HotTopicFilter.all,
    this.allHotTopics = const [],
    this.filteredHotTopics = const [],
    this.isFiltersVisible = true,
  });

  HotTopicsState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    HotTopicFilter? activeFilter,
    List<NewsArticle>? allHotTopics,
    List<NewsArticle>? filteredHotTopics,
    bool? isFiltersVisible,
  }) {
    return HotTopicsState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      activeFilter: activeFilter ?? this.activeFilter,
      allHotTopics: allHotTopics ?? this.allHotTopics,
      filteredHotTopics: filteredHotTopics ?? this.filteredHotTopics,
      isFiltersVisible: isFiltersVisible ?? this.isFiltersVisible,
    );
  }

  // View logic originally from ViewModel
  NewsArticle? get heroArticle =>
      activeFilter == HotTopicFilter.all && allHotTopics.isNotEmpty
          ? allHotTopics.first
          : null;

  List<NewsArticle> get rankedArticles =>
      activeFilter == HotTopicFilter.all && filteredHotTopics.isNotEmpty
          ? filteredHotTopics.skip(1).toList()
          : filteredHotTopics;

  int get totalHotStories => filteredHotTopics.length;
  int get trendingCount => allHotTopics.length;
  int get sourcesCount => allHotTopics.map((e) => e.source).toSet().length;
  int get categoriesCount => allHotTopics.map((e) => e.category).toSet().length;
}
