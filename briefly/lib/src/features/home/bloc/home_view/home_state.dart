import 'package:equatable/equatable.dart';
import '../../../../domain/models/news_article.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final String? error;
  final NewsArticle? featured;
  final List<NewsArticle> trending;
  final List<NewsArticle> hotTopics;
  final List<String> categories;
  final String selectedCategory;

  const HomeState({
    this.isLoading = false,
    this.error,
    this.featured,
    this.trending = const [],
    this.hotTopics = const [],
    this.categories = const [
      'All',
      'Business',
      'Technology',
      'Health',
      'Science',
      'Sports',
      'Entertainment',
    ],
    this.selectedCategory = 'All',
  });

  HomeState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    NewsArticle? featured,
    bool clearFeatured = false,
    List<NewsArticle>? trending,
    List<NewsArticle>? hotTopics,
    List<String>? categories,
    String? selectedCategory,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      featured: clearFeatured ? null : (featured ?? this.featured),
      trending: trending ?? this.trending,
      hotTopics: hotTopics ?? this.hotTopics,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    error,
    featured,
    trending,
    hotTopics,
    categories,
    selectedCategory,
  ];
}
