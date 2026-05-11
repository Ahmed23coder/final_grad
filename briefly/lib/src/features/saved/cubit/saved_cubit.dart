import 'package:flutter_bloc/flutter_bloc.dart';
import 'saved_state.dart';
import '../../../domain/models/news_article.dart';
import '../../../domain/repositories/news_repository.dart';

class SavedCubit extends Cubit<SavedState> {
  final NewsRepository _newsRepository;

  SavedCubit(this._newsRepository) : super(const SavedState());

  Future<void> loadSaved() async {
    emit(state.copyWith(status: SavedStatus.loading));
    try {
      final saved = await _newsRepository.getSavedArticles();
      if (saved.isEmpty) {
        emit(
          state.copyWith(
            status: SavedStatus.empty,
            savedArticles: [],
            filteredArticles: [],
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SavedStatus.success,
            savedArticles: saved,
            filteredArticles: _applyFilters(
              saved,
              state.searchQuery ?? '',
              state.selectedCategory,
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: SavedStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void updateSearchQuery(String query) {
    emit(
      state.copyWith(
        searchQuery: query,
        filteredArticles: _applyFilters(
          state.savedArticles,
          query,
          state.selectedCategory,
        ),
      ),
    );
  }

  void updateCategory(String category) {
    emit(
      state.copyWith(
        selectedCategory: category,
        filteredArticles: _applyFilters(
          state.savedArticles,
          state.searchQuery ?? '',
          category,
        ),
      ),
    );
  }

  void toggleSelectionMode() {
    emit(
      state.copyWith(
        isSelectionMode: !state.isSelectionMode,
        selectedIds: {}, // Clear selection when toggling
      ),
    );
  }

  void toggleArticleSelection(String id) {
    final newSelected = Set<String>.from(state.selectedIds);
    if (newSelected.contains(id)) {
      newSelected.remove(id);
    } else {
      newSelected.add(id);
    }
    emit(state.copyWith(selectedIds: newSelected));
  }

  Future<void> deleteSelected() async {
    if (state.selectedIds.isEmpty) return;

    emit(state.copyWith(status: SavedStatus.loading));
    try {
      await _newsRepository.removeArticles(state.selectedIds.toList());

      // Reload after deletion
      final saved = await _newsRepository.getSavedArticles();
      if (saved.isEmpty) {
        emit(
          state.copyWith(
            status: SavedStatus.empty,
            savedArticles: [],
            filteredArticles: [],
            isSelectionMode: false,
            selectedIds: {},
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SavedStatus.success,
            savedArticles: saved,
            filteredArticles: _applyFilters(
              saved,
              state.searchQuery ?? '',
              state.selectedCategory,
            ),
            isSelectionMode: false,
            selectedIds: {},
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: SavedStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> remove(String articleId) async {
    emit(state.copyWith(status: SavedStatus.loading));
    try {
      await _newsRepository.removeArticles([articleId]);
      await loadSaved();
    } catch (e) {
      emit(
        state.copyWith(status: SavedStatus.error, errorMessage: e.toString()),
      );
    }
  }

  List<NewsArticle> _applyFilters(
    List<NewsArticle> articles,
    String query,
    String category,
  ) {
    var filtered = articles;

    if (category != 'All') {
      filtered = filtered.where((a) => a.category == category).toList();
    }

    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      filtered = filtered
          .where(
            (a) =>
                a.title.toLowerCase().contains(q) ||
                a.source.toLowerCase().contains(q),
          )
          .toList();
    }

    return filtered;
  }
}
