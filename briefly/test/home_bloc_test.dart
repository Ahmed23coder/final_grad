import 'package:bloc_test/bloc_test.dart';
import 'package:briefly/src/domain/models/news_article.dart';
import 'package:briefly/src/domain/repositories/news_repository.dart';
import 'package:briefly/src/features/home/bloc/home_view/home_bloc.dart';
import 'package:briefly/src/features/home/bloc/home_view/home_event.dart';
import 'package:briefly/src/features/home/bloc/home_view/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeNewsRepository implements NewsRepository {
  _FakeNewsRepository({
    this.featured,
    this.trending = const [],
    this.hotTopics = const [],
  });

  final NewsArticle? featured;
  final List<NewsArticle> trending;
  final List<NewsArticle> hotTopics;

  @override
  Future<List<String>> getCategories() async => [];

  @override
  Future<List<NewsArticle>> getTrendingArticles() async {
    return trending;
  }

  @override
  Future<List<NewsArticle>> getArticlesByCategory(String category) async {
    return hotTopics;
  }

  @override
  Future<NewsArticle> getArticleById(String id) async {
    return featured!;
  }

  @override
  Future<List<NewsArticle>> getReadingHistory() async => [];

  @override
  Future<List<NewsArticle>> getSavedArticles() async => [];

  @override
  Future<void> addToReadingHistory(NewsArticle article) async {}

  @override
  Future<void> saveArticle(NewsArticle article) async {}

  @override
  Future<void> removeArticles(List<String> ids) async {}

  @override
  Future<bool> isArticleSaved(String articleId) async => false;

  @override
  Future<NewsArticle?> fetchFeaturedArticle({String? category}) async {
    return featured;
  }

  @override
  Future<List<NewsArticle>> fetchTrendingArticles({String? category}) async {
    final items = <NewsArticle>[if (featured != null) featured!, ...trending];
    return items;
  }

  @override
  Future<List<NewsArticle>> fetchHotTopics({String? category}) async {
    return hotTopics;
  }

  @override
  Future<String> summarizeArticle(String content) async {
    return 'Mock Summary';
  }
}

void main() {
  group('HomeBloc', () {
    blocTest<HomeBloc, HomeState>(
      'emits loading then content on LoadHomeFeed',
      build: () {
        final repo = _FakeNewsRepository(
          featured: NewsArticle(
            id: 'f1',
            category: 'All',
            title: 'Featured',
            urlToImage: '',
            publishedAt: DateTime(2026, 1, 1),
            source: 'Src',
            content: 'c',
            trendingScore: 1.0,
          ),
          trending: [
            NewsArticle(
              id: 't1',
              category: 'All',
              title: 'Trending',
              urlToImage: '',
              publishedAt: DateTime(2026, 1, 1),
              source: 'Src',
              content: 'c',
              trendingScore: 1.0,
            ),
          ],
          hotTopics: [
            NewsArticle(
              id: 'h1',
              category: 'All',
              title: 'Hot',
              urlToImage: '',
              publishedAt: DateTime(2026, 1, 1),
              source: 'Src',
              content: 'c',
              trendingScore: 1.0,
            ),
          ],
        );
        return HomeBloc(repo);
      },
      act: (bloc) => bloc.add(LoadHomeFeed()),
      expect: () => [
        isA<HomeState>().having((s) => s.isLoading, 'isLoading', true),
        isA<HomeState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.featured?.id, 'featured', 'f1')
            .having((s) => s.trending.length, 'trending.length', 1)
            .having((s) => s.hotTopics.length, 'hotTopics.length', 1),
      ],
    );
  });
}
