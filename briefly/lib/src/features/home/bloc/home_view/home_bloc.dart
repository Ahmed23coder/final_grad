import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/news_repository.dart';
import '../../../../domain/models/news_article.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final NewsRepository _newsRepository;

  HomeBloc(this._newsRepository) : super(const HomeState()) {
    on<LoadHomeFeed>(_onLoadHomeFeed);
    on<SelectCategory>(_onSelectCategory);
  }

  Future<void> _onLoadHomeFeed(
    LoadHomeFeed event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final category = state.selectedCategory;
      
      // Sequential fetching with small delays and independent error handling
      NewsArticle? featured;
      try {
        featured = await _newsRepository.fetchFeaturedArticle(category: category);
      } catch (e) {
        // ignore: avoid_print
        print('HomeBloc: Featured load fail: $e');
      }
      
      await Future.delayed(const Duration(milliseconds: 300));
      
      List<NewsArticle> trending = [];
      try {
        trending = await _newsRepository.fetchTrendingArticles(category: category);
      } catch (e) {
        // ignore: avoid_print
        print('HomeBloc: Trending load fail: $e');
      }

      await Future.delayed(const Duration(milliseconds: 300));
      
      List<NewsArticle> hotTopics = [];
      try {
        hotTopics = await _newsRepository.fetchHotTopics(category: category);
      } catch (e) {
        // ignore: avoid_print
        print('HomeBloc: HotTopics load fail: $e');
      }
      
      emit(
        state.copyWith(
          isLoading: false,
          featured: featured,
          trending: trending,
          hotTopics: hotTopics,
          // Only show error if we got absolutely nothing
          error: (featured == null && trending.isEmpty && hotTopics.isEmpty) 
              ? 'Failed to load feed. Please check your connection.' 
              : null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
          clearFeatured: true,
          trending: const [],
          hotTopics: const [],
        ),
      );
    }
  }

  void _onSelectCategory(SelectCategory event, Emitter<HomeState> emit) {
    if (state.selectedCategory == event.category) return;
    emit(state.copyWith(selectedCategory: event.category));
    add(LoadHomeFeed());
  }
}
