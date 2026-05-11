import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../domain/models/news_article.dart';
import '../../../domain/repositories/news_repository.dart';
import '../../home/presentation/widgets/article_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<NewsArticle> _articles = const [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final articles = await context
          .read<NewsRepository>()
          .getTrendingArticles();
      if (!mounted) return;
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load articles.';
        _isLoading = false;
      });
    }
  }

  List<NewsArticle> get _results {
    final query = _controller.text.trim().toLowerCase();
    if (query.isEmpty) return _articles;
    return _articles.where((article) {
      return article.title.toLowerCase().contains(query) ||
          article.source.toLowerCase().contains(query) ||
          article.category.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.scaleWidth(20),
                context.scaleHeight(16),
                context.scaleWidth(20),
                context.scaleHeight(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search',
                    style: AppTextStyles.h1(
                      context,
                    ).copyWith(fontSize: context.scaleFontSize(24)),
                  ),
                  SizedBox(height: context.scaleHeight(12)),
                  _SearchField(
                    controller: _controller,
                    onChanged: (_) => setState(() {}),
                    onClear: () {
                      _controller.clear();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryAccent,
                      ),
                    )
                  : _error != null
                  ? _Message(text: _error!)
                  : results.isEmpty
                  ? const _Message(text: 'No articles match your search.')
                  : RefreshIndicator(
                      color: AppColors.primaryAccent,
                      backgroundColor: AppColors.background,
                      onRefresh: _load,
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          context.scaleWidth(20),
                          0,
                          context.scaleWidth(20),
                          context.scaleHeight(120),
                        ),
                        itemCount: results.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: context.scaleHeight(12)),
                        itemBuilder: (context, index) {
                          final article = results[index];
                          return ArticleCard(
                            title: article.title,
                            category: article.category,
                            source: article.source,
                            timeAgo: article.timeAgo,
                            thumbnailUrl: article.thumbnailUrl,
                            isFlat: false,
                            onTap: () => context.push(
                              '/article/${article.id}',
                              extra: article,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.scaleHeight(48),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          SizedBox(width: context.scaleWidth(16)),
          Icon(
            LucideIcons.search,
            color: AppColors.silverSecondaryLabel,
            size: context.scaleWidth(18),
          ),
          SizedBox(width: context.scaleWidth(10)),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTextStyles.inputText(context),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search articles, sources, categories',
                hintStyle: AppTextStyles.caption(context).copyWith(
                  color: AppColors.silverPlaceholder,
                  fontSize: context.scaleFontSize(13),
                ),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              onPressed: onClear,
              icon: Icon(
                LucideIcons.x,
                color: AppColors.silverSecondaryLabel,
                size: context.scaleWidth(16),
              ),
            ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final String text;

  const _Message({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(24)),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.body(
            context,
          ).copyWith(color: AppColors.silverSecondaryLabel),
        ),
      ),
    );
  }
}
