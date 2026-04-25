import '../models/news_article.dart';

abstract class NewsRepository {
  /// Fetches available news categories.
  Future<List<String>> getCategories();

  /// Fetches trending news articles (default home view).
  Future<List<NewsArticle>> getTrendingArticles();

  /// Fetches news articles filtered by a specific category.
  Future<List<NewsArticle>> getArticlesByCategory(String category);

  /// Fetches a single article by its ID.
  Future<NewsArticle> getArticleById(String id);

  /// Fetches the user's reading history.
  Future<List<NewsArticle>> getReadingHistory();

  /// Fetches the user's saved articles (Saved).
  Future<List<NewsArticle>> getSavedArticles();

  /// Adds an article to the user's reading history.
  Future<void> addToReadingHistory(NewsArticle article);

  /// Saves an article to the Saved.
  Future<void> saveArticle(NewsArticle article);

  /// Fetches a featured article, optionally filtered by category.
  Future<NewsArticle?> fetchFeaturedArticle({String? category});

  /// Fetches trending news articles, optionally filtered by category.
  Future<List<NewsArticle>> fetchTrendingArticles({String? category});

  /// Fetches hot topics articles, optionally filtered by category.
  Future<List<NewsArticle>> fetchHotTopics({String? category});

  /// Removes articles from the Saved by IDs.
  Future<void> removeArticles(List<String> ids);
  /// Generates a deeper AI summary for a specific article.
  Future<String> summarizeArticle(String content);
}
