import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/news_article.dart';
import '../../../../domain/repositories/news_repository.dart';
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

    final category = state.selectedCategory;

    final results = await Future.wait<Object?>([
      _newsRepository.fetchFeaturedArticle(category: category).catchError((
        Object e,
      ) {
        developer.log('Featured load failed', name: 'home', error: e);
        return null;
      }),
      _newsRepository.fetchTrendingArticles(category: category).catchError((
        Object e,
      ) {
        developer.log('Trending load failed', name: 'home', error: e);
        return <NewsArticle>[];
      }),
      _newsRepository.fetchHotTopics(category: category).catchError((Object e) {
        developer.log('HotTopics load failed', name: 'home', error: e);
        return <NewsArticle>[];
      }),
    ]);

    final featured = results[0] as NewsArticle?;
    final trending = (results[1] as List).cast<NewsArticle>();
    final hotTopics = (results[2] as List).cast<NewsArticle>();

    emit(
      state.copyWith(
        isLoading: false,
        featured: featured,
        trending: trending,
        hotTopics: hotTopics,
        error: (featured == null && trending.isEmpty && hotTopics.isEmpty)
            ? 'Failed to load feed. Please check your connection.'
            : null,
      ),
    );
  }

  void _onSelectCategory(SelectCategory event, Emitter<HomeState> emit) {
    if (state.selectedCategory == event.category) return;
    emit(state.copyWith(selectedCategory: event.category));
    add(LoadHomeFeed());
  }
}
