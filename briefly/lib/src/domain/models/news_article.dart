import 'package:equatable/equatable.dart';

class NewsArticle extends Equatable {
  final String id;
  final String category;
  final String title;
  final String urlToImage;
  final DateTime publishedAt;
  final String source;
  final String content;
  final double trendingScore;

  const NewsArticle({
    required this.id,
    required this.category,
    required this.title,
    required this.urlToImage,
    required this.publishedAt,
    required this.source,
    required this.content,
    this.trendingScore = 0.0,
  });

  String? get thumbnailUrl => urlToImage.isNotEmpty ? urlToImage : null;

  String get timeAgo {
    final difference = DateTime.now().difference(publishedAt);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    final sourceValue = json['source'] ?? json['channels'];
    final sourceName = sourceValue is Map<String, dynamic>
        ? sourceValue['name']?.toString() ?? 'Unknown Source'
        : sourceValue?.toString() ?? 'Unknown Source';

    final categoryValue = json['category'] ?? json['categories'];
    final categoryName = categoryValue is Map<String, dynamic>
        ? categoryValue['name']?.toString() ?? 'General'
        : categoryValue?.toString() ?? 'General';

    return NewsArticle(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      category: categoryName,
      title: json['title']?.toString() ?? '',
      urlToImage: (json['urlToImage'] ?? json['cover_image_url'])?.toString() ?? '',
      publishedAt:
          DateTime.tryParse((json['publishedAt'] ?? json['published_at'])?.toString() ?? '') ??
          DateTime.now(),
      source: sourceName,
      content: json['content']?.toString() ?? '',
      trendingScore: (json['trendingScore'] ?? json['view_count'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.toIso8601String(),
      'source': {'name': source},
      'content': content,
      'trendingScore': trendingScore,
    };
  }

  NewsArticle copyWith({
    String? id,
    String? category,
    String? title,
    String? urlToImage,
    DateTime? publishedAt,
    String? source,
    String? content,
    double? trendingScore,
  }) {
    return NewsArticle(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      source: source ?? this.source,
      content: content ?? this.content,
      trendingScore: trendingScore ?? this.trendingScore,
    );
  }

  @override
  List<Object?> get props => [
        id,
        category,
        title,
        urlToImage,
        publishedAt,
        source,
        content,
        trendingScore,
      ];
}
