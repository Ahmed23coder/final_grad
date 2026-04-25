import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/models/hot_topic_filter.dart';
import '../../../../domain/repositories/news_repository.dart';
import 'hot_topics_event.dart';
import 'hot_topics_state.dart';

class HotTopicsBloc extends Bloc<HotTopicsEvent, HotTopicsState> {
  final NewsRepository _newsRepository;

  HotTopicsBloc(
    this._newsRepository, {
    HotTopicFilter initialFilter = HotTopicFilter.all,
  }) : super(HotTopicsState(activeFilter: initialFilter)) {
    on<LoadHotTopics>(_onLoadHotTopics);
    on<ChangeFilter>(_onChangeFilter);
    on<ToggleFilters>(_onToggleFilters);
  }

  Future<void> _onLoadHotTopics(
    LoadHotTopics event,
    Emitter<HotTopicsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      // Fetch trending hot topics from repo
      final articles = await _newsRepository.fetchTrendingArticles();
      // Sort by trending score
      articles.sort((a, b) => b.trendingScore.compareTo(a.trendingScore));

      emit(state.copyWith(
        isLoading: false,
        allHotTopics: articles,
        filteredHotTopics: articles,
      ));
      
      // Re-apply filter logic if needed
      if (state.activeFilter != HotTopicFilter.all) {
        add(ChangeFilter(state.activeFilter));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onChangeFilter(
    ChangeFilter event,
    Emitter<HotTopicsState> emit,
  ) async {
    if (state.activeFilter == event.filter && state.allHotTopics.isNotEmpty) return;

    emit(state.copyWith(activeFilter: event.filter, isLoading: true));

    try {
      final categoryKey = event.filter == HotTopicFilter.all ? null : _getCategoryKey(event.filter);
      
      // Small delay to prevent rapid-fire API hits
      await Future.delayed(const Duration(milliseconds: 300));
      
      final articles = await _newsRepository.fetchHotTopics(category: categoryKey);
      
      emit(state.copyWith(
        isLoading: false,
        allHotTopics: articles,
        filteredHotTopics: articles,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onToggleFilters(
    ToggleFilters event,
    Emitter<HotTopicsState> emit,
  ) {
    emit(state.copyWith(isFiltersVisible: !state.isFiltersVisible));
  }

  String _getCategoryKey(HotTopicFilter filter) {
    switch (filter) {
      case HotTopicFilter.technology:
        return 'Technology';
      case HotTopicFilter.world:
        return 'World';
      case HotTopicFilter.finance:
        return 'Business';
      case HotTopicFilter.science:
        return 'Science';
      case HotTopicFilter.health:
        return 'Health';
      case HotTopicFilter.environment:
        return 'Environment';
      case HotTopicFilter.sports:
        return 'Sports';
      case HotTopicFilter.entertainment:
        return 'Entertainment';
      default:
        return '';
    }
  }
}
