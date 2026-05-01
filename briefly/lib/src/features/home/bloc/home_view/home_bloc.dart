import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/news_article.dart';
import '../../../../domain/repositories/news_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static const _fetchTimeout = Duration(seconds: 12);

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

    // fetchFeaturedArticle and fetchTrendingArticles hit the same edge-function
    // endpoint (action=fetchArticles, type=reg). Make one call, derive both,
    // and run hot-topics (type=hot) in parallel.
    Future<List<NewsArticle>> safeRegArticles() async {
      try {
        return await _newsRepository
            .fetchTrendingArticles(category: category)
            .timeout(_fetchTimeout);
      } catch (e, st) {
        developer.log(
          'Trending/Featured load failed',
          name: 'home',
          error: e,
          stackTrace: st,
        );
        return const [];
      }
    }

    Future<List<NewsArticle>> safeHotTopics() async {
      try {
        return await _newsRepository
            .fetchHotTopics(category: category)
            .timeout(_fetchTimeout);
      } catch (e, st) {
        developer.log(
          'HotTopics load failed',
          name: 'home',
          error: e,
          stackTrace: st,
        );
        return const [];
      }
    }

    final results = await Future.wait([safeRegArticles(), safeHotTopics()]);
    final regArticles = results[0];
    final hotTopics = results[1];

    final featured = regArticles.isNotEmpty ? regArticles.first : null;
    // The featured article is rendered separately as the hero card. Drop it
    // from the trending carousel so the same story doesn't appear twice.
    final trending = regArticles.length > 1
        ? regArticles.sublist(1)
        : const <NewsArticle>[];

    // De-duplicate hot topics by title so multiple wire-service reposts of the
    // same story collapse into one row (e.g. Business Insider + Yahoo both
    // running the identical headline). Keep the first occurrence (highest-
    // ranked source).
    final seenTitles = <String>{};
    final dedupedHotTopics = <NewsArticle>[];
    for (final article in hotTopics) {
      final key = article.title.trim().toLowerCase();
      if (seenTitles.add(key)) dedupedHotTopics.add(article);
    }

    emit(
      state.copyWith(
        isLoading: false,
        featured: featured,
        trending: trending,
        hotTopics: dedupedHotTopics,
        clearFeatured: featured == null,
        error:
            (featured == null && trending.isEmpty && dedupedHotTopics.isEmpty)
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
