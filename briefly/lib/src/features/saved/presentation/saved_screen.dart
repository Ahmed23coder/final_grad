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
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key, this.isTab = true});

  final bool isTab;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SavedCubit(context.read<NewsRepository>())..loadSaved(),
      child: _SavedView(isTab: isTab),
    );
  }
}

class _SavedView extends StatelessWidget {
  const _SavedView({required this.isTab});

  final bool isTab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<SavedCubit, SavedState>(
          builder: (context, state) {
            return Column(
              children: [
                _Header(isTab: isTab, count: state.savedArticles.length),
                if (state.savedArticles.isNotEmpty)
                  _VaultControls(state: state),
                Expanded(child: _Body(state: state)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isTab, required this.count});

  final int count;
  final bool isTab;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleWidth(16),
        vertical: context.scaleHeight(12),
      ),
      child: Row(
        children: [
          if (!isTab)
            InkResponse(
              onTap: () => context.pop(),
              radius: context.scaleWidth(18),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  LucideIcons.arrowLeft,
                  color: AppColors.foreground,
                  size: context.scaleWidth(18),
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vault',
                  style: AppTextStyles.h1(
                    context,
                  ).copyWith(fontSize: context.scaleFontSize(22)),
                ),
                SizedBox(height: context.scaleHeight(2)),
                Text(
                  '$count saved',
                  style: AppTextStyles.caption(
                    context,
                  ).copyWith(color: AppColors.silverSecondaryLabel),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.read<SavedCubit>().loadSaved(),
            icon: Icon(
              LucideIcons.refreshCw,
              color: AppColors.silverSecondaryLabel,
              size: context.scaleWidth(18),
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final SavedState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == SavedStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryAccent),
      );
    }

    if (state.status == SavedStatus.error) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(20)),
          child: Text(
            state.errorMessage ?? 'Failed to load saved articles.',
            textAlign: TextAlign.center,
            style: AppTextStyles.error(context),
          ),
        ),
      );
    }

    if (state.savedArticles.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(20)),
          child: Text(
            'No saved articles yet.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body(
              context,
            ).copyWith(color: AppColors.silverSecondaryLabel),
          ),
        ),
      );
    }

    final hasActiveFilters =
        (state.searchQuery ?? '').trim().isNotEmpty ||
        state.selectedCategory != 'All';
    final articles = hasActiveFilters
        ? state.filteredArticles
        : state.savedArticles;

    if (articles.isEmpty) {
      return const _EmptyMessage(text: 'No saved articles match your filters.');
    }

    return RefreshIndicator(
      onRefresh: () => context.read<SavedCubit>().loadSaved(),
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(
          context.scaleWidth(16),
          0,
          context.scaleWidth(16),
          context.scaleHeight(120),
        ),
        itemBuilder: (context, index) {
          final NewsArticle article = articles[index];
          return Dismissible(
            key: ValueKey('saved_${article.id}'),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: context.scaleWidth(16)),
              decoration: BoxDecoration(
                color: AppColors.primaryAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                LucideIcons.trash2,
                color: AppColors.primaryAccent,
              ),
            ),
            onDismissed: (_) => context.read<SavedCubit>().remove(article.id),
            child: ArticleCard(
              title: article.title,
              category: article.category,
              source: article.source,
              timeAgo: article.timeAgo,
              thumbnailUrl: article.thumbnailUrl,
              onTap: () =>
                  context.push('/article/${article.id}', extra: article),
              isFlat: false,
              isSaved: true,
            ),
          );
        },
        separatorBuilder: (_, __) => SizedBox(height: context.scaleHeight(12)),
        itemCount: articles.length,
      ),
    );
  }
}

class _VaultControls extends StatelessWidget {
  const _VaultControls({required this.state});

  final SavedState state;

  @override
  Widget build(BuildContext context) {
    final categories = <String>{
      'All',
      ...state.savedArticles.map((article) => article.category),
    }.toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.scaleWidth(16),
        0,
        context.scaleWidth(16),
        context.scaleHeight(12),
      ),
      child: Column(
        children: [
          _VaultSearchField(query: state.searchQuery ?? ''),
          SizedBox(height: context.scaleHeight(10)),
          SizedBox(
            height: context.scaleHeight(36),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final category = categories[index];
                final selected = state.selectedCategory == category;
                return InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () =>
                      context.read<SavedCubit>().updateCategory(category),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scaleWidth(14),
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primaryAccent
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: selected
                            ? AppColors.primaryAccent
                            : AppColors.borderColor,
                      ),
                    ),
                    child: Text(
                      category,
                      style: AppTextStyles.buttonLabel(context).copyWith(
                        color: selected
                            ? AppColors.primaryForeground
                            : AppColors.silverSecondaryLabel,
                        fontSize: context.scaleFontSize(12),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) =>
                  SizedBox(width: context.scaleWidth(8)),
              itemCount: categories.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _VaultSearchField extends StatefulWidget {
  const _VaultSearchField({required this.query});

  final String query;

  @override
  State<_VaultSearchField> createState() => _VaultSearchFieldState();
}

class _VaultSearchFieldState extends State<_VaultSearchField> {
  late final TextEditingController _controller;

  @override
  void didUpdateWidget(_VaultSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _controller.text) {
      _controller.text = widget.query;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.scaleHeight(46),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          SizedBox(width: context.scaleWidth(14)),
          Icon(
            LucideIcons.search,
            color: AppColors.silverSecondaryLabel,
            size: context.scaleWidth(17),
          ),
          SizedBox(width: context.scaleWidth(10)),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (value) =>
                  context.read<SavedCubit>().updateSearchQuery(value),
              style: AppTextStyles.inputText(context),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search your vault',
                hintStyle: AppTextStyles.caption(context).copyWith(
                  color: AppColors.silverPlaceholder,
                  fontSize: context.scaleFontSize(13),
                ),
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _controller.clear();
                context.read<SavedCubit>().updateSearchQuery('');
              },
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

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(20)),
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
