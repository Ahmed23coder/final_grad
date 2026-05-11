import 'package:equatable/equatable.dart';
import '../../../domain/models/news_article.dart';

enum SavedStatus { initial, loading, success, empty, error }

class SavedState extends Equatable {
  final SavedStatus status;
  final List<NewsArticle> savedArticles;
  final List<NewsArticle> filteredArticles;
  final bool isSelectionMode;
  final Set<String> selectedIds;
  final String? searchQuery;
  final String selectedCategory;
  final String? errorMessage;

  const SavedState({
    this.status = SavedStatus.initial,
    this.savedArticles = const [],
    this.filteredArticles = const [],
    this.isSelectionMode = false,
    this.selectedIds = const {},
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.errorMessage,
  });

  SavedState copyWith({
    SavedStatus? status,
    List<NewsArticle>? savedArticles,
    List<NewsArticle>? filteredArticles,
    bool? isSelectionMode,
    Set<String>? selectedIds,
    String? searchQuery,
    String? selectedCategory,
    String? errorMessage,
  }) {
    return SavedState(
      status: status ?? this.status,
      savedArticles: savedArticles ?? this.savedArticles,
      filteredArticles: filteredArticles ?? this.filteredArticles,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedIds: selectedIds ?? this.selectedIds,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        savedArticles,
        filteredArticles,
        isSelectionMode,
        selectedIds,
        searchQuery,
        selectedCategory,
        errorMessage,
      ];
}



