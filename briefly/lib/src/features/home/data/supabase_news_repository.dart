import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/news_article.dart';
import '../../../domain/repositories/news_repository.dart';

class SupabaseNewsRepository implements NewsRepository {
  final SupabaseClient _client;

  SupabaseNewsRepository(this._client);

  /// Private helper to invoke the news-proxy edge function.
  Future<List<NewsArticle>> _invokeNewsProxy({
    required String action,
    String? category,
    String? id,
    String type = 'reg',
  }) async {
    try {
      final response = await _client.functions.invoke(
        'news-proxy',
        body: {
          'action': action,
          'category': category,
          'id': id,
          'type': type,
        },
      );

      if (response.status != 200) {
        throw Exception('Failed to invoke news-proxy: ${response.data}');
      }

      final List<dynamic> data = response.data;
      return data.map((json) => NewsArticle.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getCategories() async {
    return ['All', 'Egypt', 'World', 'Business', 'Technology', 'Entertainment', 'Science', 'Health', 'Sports'];
  }

  @override
  Future<List<NewsArticle>> getTrendingArticles() async {
    return fetchTrendingArticles();
  }

  @override
  Future<List<NewsArticle>> getArticlesByCategory(String category) async {
    return _invokeNewsProxy(action: 'fetchArticles', category: category);
  }

  @override
  Future<NewsArticle> getArticleById(String id) async {
    final articles = await _invokeNewsProxy(action: 'getArticleById', id: id);
    if (articles.isEmpty) throw Exception('Article not found');

    return articles.first;
  }

  @override
  Future<List<NewsArticle>> getReadingHistory() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final data = await _client
        .from('reading_history')
        .select('article_snapshot, last_read_at')
        .eq('user_id', user.id)
        .order('last_read_at', ascending: false);

    return (data as List).map((json) {
      final snapshot = Map<String, dynamic>.from(json['article_snapshot'] as Map);
      // Inject last_read_at so the cubit can group by actual read date
      snapshot['last_read_at'] = json['last_read_at'];
      return NewsArticle.fromJson(snapshot);
    }).toList();
  }

  @override
  Future<List<NewsArticle>> getSavedArticles() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final data = await _client
        .from('saved_articles')
        .select('article_snapshot')
        .eq('user_id', user.id)
        .order('saved_at', ascending: false);

    return (data as List)
        .map(
          (json) => NewsArticle.fromJson(
            Map<String, dynamic>.from(json['article_snapshot'] as Map),
          ),
        )
        .toList();
  }

  @override
  Future<bool> isArticleSaved(String articleId) async {
    final user = _client.auth.currentUser;
    if (user == null) return false;

    final data = await _client
        .from('saved_articles')
        .select('article_id')
        .eq('user_id', user.id)
        .eq('article_id', articleId)
        .maybeSingle();

    return data != null;
  }

  @override
  Future<void> addToReadingHistory(NewsArticle article) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    try {
      await _client.from('reading_history').upsert({
        'user_id': user.id,
        'article_id': article.id,
        'article_snapshot': article.toJson(),
        'last_read_at': DateTime.now().toIso8601String(),
        'completion_percentage': 0,
      }, onConflict: 'user_id, article_id');
    } catch (e) {
      // ignore
    }
  }

  @override
  Future<void> saveArticle(NewsArticle article) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    try {
      await _client.from('saved_articles').upsert({
        'user_id': user.id,
        'article_id': article.id,
        'article_snapshot': article.toJson(),
      }, onConflict: 'user_id, article_id');
    } catch (e) {
      // ignore
    }
  }

  @override
  Future<NewsArticle?> fetchFeaturedArticle({String? category}) async {
    final articles = await _invokeNewsProxy(action: 'fetchArticles', category: category);
    if (articles.isNotEmpty) {
      return articles.first;
    }
    return null;
  }

  @override
  Future<List<NewsArticle>> fetchTrendingArticles({String? category}) async {
    final articles = await _invokeNewsProxy(action: 'fetchArticles', category: category);
    articles.sort((a, b) => b.trendingScore.compareTo(a.trendingScore));
    return articles.take(15).toList();
  }

  @override
  Future<List<NewsArticle>> fetchHotTopics({String? category}) async {
    final articles = await _invokeNewsProxy(action: 'fetchArticles', category: category, type: 'hot');
    return articles.take(20).toList();
  }

  @override
  Future<void> removeArticles(List<String> ids) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    if (ids.isEmpty) return;

    await _client
        .from('saved_articles')
        .delete()
        .eq('user_id', user.id)
      .inFilter('article_id', ids);
  }

  @override
  Future<String> summarizeArticle(String content) async {
    try {
      final response = await _client.functions.invoke(
        'news-proxy',
        body: {
          'action': 'summarize',
          'content': content,
        },
      );

      if (response.status != 200) {
        throw Exception('Failed to summarize: ${response.data}');
      }

      return response.data['summary'] ?? 'Failed to generate summary';
    } catch (e, st) {
      developer.log(
        'summarizeArticle failed',
        name: 'news',
        error: e,
        stackTrace: st,
      );
      return 'AI summarization unavailable at the moment.';
    }
  }
}
