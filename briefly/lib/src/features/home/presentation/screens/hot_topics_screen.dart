import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../core/utils/app_animations.dart';
import '../../../../domain/models/hot_topic_filter.dart';
import '../../../../domain/models/news_article.dart';
import '../../../../domain/repositories/news_repository.dart';
import '../../bloc/hot_topics/hot_topics_bloc.dart';
import '../../bloc/hot_topics/hot_topics_event.dart';
import '../../bloc/hot_topics/hot_topics_state.dart';

String _formatViewsCount(double trendingScore) {
  final views = (trendingScore * 120).round();
  if (views >= 1000) {
    final kilo = views / 1000;
    return '${kilo.toStringAsFixed(kilo.truncateToDouble() == kilo ? 0 : 1)}k';
  }
  return views.toString();
}

class HotTopicsView extends StatelessWidget {
  final HotTopicFilter initialFilter;

  const HotTopicsView({super.key, required this.initialFilter});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HotTopicsBloc(
        context.read<NewsRepository>(),
        initialFilter: initialFilter,
      )..add(LoadHotTopics()),
      child: const HotTopicsScreen(),
    );
  }
}

class HotTopicsScreen extends StatelessWidget {
  const HotTopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HotTopicsBloc, HotTopicsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(context, state),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildScrollableContent(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, HotTopicsState state) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leadingWidth: context.scaleWidth(56),
      titleSpacing: 0,
      centerTitle: false,
      leading: Center(
        child: PressScaleAnimation(
          onTap: () => context.pop(),
          child: Container(
            width: context.scaleWidth(40),
            height: context.scaleWidth(40),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            ),
            alignment: Alignment.center,
            child: Icon(
              LucideIcons.arrowLeft,
              color: AppColors.silverPlaceholder,
              size: context.scaleWidth(18),
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.scaleWidth(24),
            height: context.scaleWidth(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF97316).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              LucideIcons.flame,
              color: const Color(0xFFF97316),
              size: context.scaleWidth(14),
            ),
          ),
          SizedBox(width: context.scaleWidth(6)),
          Text(
            'Hot Topics',
            style: TextStyle(
              fontFamily: 'Newsreader',
              fontWeight: FontWeight.w700,
              fontSize: context.scaleFontSize(20),
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        Center(
          child: PressScaleAnimation(
            onTap: () => context.read<HotTopicsBloc>().add(ToggleFilters()),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: context.scaleWidth(40),
              height: context.scaleWidth(40),
              decoration: BoxDecoration(
                color: state.isFiltersVisible
                    ? AppColors.silverPlaceholder.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: state.isFiltersVisible
                      ? AppColors.silverPlaceholder.withValues(alpha: 0.30)
                      : Colors.white.withValues(alpha: 0.10),
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                LucideIcons.listFilter,
                color: state.isFiltersVisible ? Colors.white : AppColors.silverPlaceholder,
                size: context.scaleWidth(16),
              ),
            ),
          ),
        ),
        SizedBox(width: context.scaleWidth(20)),
      ],
    );
  }

  Widget _buildFilterPills(BuildContext context, HotTopicsState state) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: state.isFiltersVisible
          ? AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: 1.0,
              child: SizedBox(
                height: context.scaleHeight(36),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(20)),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: HotTopicFilter.values.length,
                  separatorBuilder: (_, __) => SizedBox(width: context.scaleWidth(8)),
                  itemBuilder: (context, index) {
                    final filter = HotTopicFilter.values[index];
                    final isActive = state.activeFilter == filter;
                    final capitalizedName = filter.name[0].toUpperCase() + filter.name.substring(1).toLowerCase();

                    return PressScaleAnimation(
                      key: ValueKey('filter_${filter.name}'),
                      onTap: () => context.read<HotTopicsBloc>().add(ChangeFilter(filter)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.scaleWidth(16),
                          vertical: context.scaleHeight(8),
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFF97316).withValues(alpha: 0.20)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: isActive
                                ? const Color(0xFFF97316).withValues(alpha: 0.40)
                                : Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Text(
                          capitalizedName.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                            fontSize: context.scaleFontSize(10),
                            color: isActive
                                ? const Color(0xFFFDBA74)
                                : AppColors.silverPlaceholder.withValues(alpha: 0.50),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          : const SizedBox(width: double.infinity, height: 0),
    );
  }

  Widget _buildScrollableContent(BuildContext context, HotTopicsState state) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: context.scaleHeight(48)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.scaleHeight(16)),
          
          // 1. Animated Filter Pills (now scrolls with content)
          _buildFilterPills(context, state),
          
          SizedBox(height: context.scaleHeight(24)),
          
          PageEntranceAnimation(
            delay: const Duration(milliseconds: 100),
            slideOffset: -4.0,
            child: _buildLiveIndicator(context, state),
          ),

          if (state.activeFilter == HotTopicFilter.all && state.heroArticle != null) ...[
            SizedBox(height: context.scaleHeight(16)),
            PageEntranceAnimation(
              delay: const Duration(milliseconds: 150),
              child: _buildHeroCard(context, state.heroArticle!),
            ),
            SizedBox(height: context.scaleHeight(16)),
            PageEntranceAnimation(
              delay: const Duration(milliseconds: 200),
              child: _buildStatsRow(context, state),
            ),
          ],

          SizedBox(height: context.scaleHeight(24)),
          _buildSectionLabel(context, state),
          SizedBox(height: context.scaleHeight(12)),
          _buildRankedList(context, state),
          SizedBox(height: context.scaleHeight(32)),
          Center(child: _buildEndMarker(context)),
        ],
      ),
    );
  }

  Widget _buildLiveIndicator(BuildContext context, HotTopicsState state) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.scaleWidth(20)),
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleWidth(12),
        vertical: context.scaleHeight(8),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xFFF97316).withValues(alpha: 0.20)),
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF97316).withValues(alpha: 0.10),
            const Color(0xFFEF4444).withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _PingDot(),
              SizedBox(width: context.scaleWidth(8)),
              Text(
                'Live â€” Updated every few minutes',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.scaleFontSize(10),
                  color: const Color(0xFFFDBA74).withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                LucideIcons.trendingUp,
                color: const Color(0xFFFDBA74).withValues(alpha: 0.6),
                size: context.scaleWidth(11),
              ),
              SizedBox(width: context.scaleWidth(4)),
              Text(
                '${state.totalHotStories} stories',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.scaleFontSize(10),
                  color: const Color(0xFFFDBA74).withValues(alpha: 0.6),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, NewsArticle article) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(20)),
      child: PressScaleAnimation(
        onTap: () => context.push('/article/${article.id}', extra: article),
        child: Container(
          height: context.scaleHeight(224),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            image: article.thumbnailUrl != null
                ? DecorationImage(
                    image: CachedNetworkImageProvider(article.thumbnailUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
            color: AppColors.secondarySurface,
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.90),
                      Colors.black.withValues(alpha: 0.40),
                      Colors.black.withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: context.scaleHeight(16),
                left: context.scaleWidth(16),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaleWidth(8),
                        vertical: context.scaleHeight(4),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF97316),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Icon(LucideIcons.flame, color: Colors.white, size: context.scaleWidth(10)),
                          SizedBox(width: context.scaleWidth(4)),
                          Text(
                            '#1 TRENDING',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: context.scaleFontSize(9),
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: context.scaleWidth(8)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaleWidth(8),
                        vertical: context.scaleHeight(4),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        article.category.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: context.scaleFontSize(9),
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: context.scaleHeight(16),
                right: context.scaleWidth(16),
                child: Container(
                  width: context.scaleWidth(32),
                  height: context.scaleWidth(32),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(LucideIcons.bookmark, color: Colors.white, size: context.scaleWidth(14)),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(context.scaleWidth(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Newsreader',
                          fontSize: context.scaleFontSize(20),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: context.scaleHeight(8)),
                      Row(
                        children: [
                          Text(
                            article.source,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.scaleFontSize(11),
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          _DotSeparator(),
                          Icon(LucideIcons.clock, color: Colors.white.withValues(alpha: 0.4), size: context.scaleWidth(11)),
                          SizedBox(width: context.scaleWidth(4)),
                          Text(
                            article.timeAgo,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.scaleFontSize(11),
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                          _DotSeparator(),
                          Icon(LucideIcons.eye, color: Colors.white.withValues(alpha: 0.4), size: context.scaleWidth(11)),
                          SizedBox(width: context.scaleWidth(4)),
                          Text(
                            _formatViewsCount(article.trendingScore),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.scaleFontSize(11),
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, HotTopicsState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(20)),
      child: Row(
        children: [
          Expanded(child: _buildStatCard(context, state.trendingCount.toString(), 'Trending', const Color(0xFFF97316), LucideIcons.trendingUp)),
          SizedBox(width: context.scaleWidth(10)),
          Expanded(child: _buildStatCard(context, state.sourcesCount.toString(), 'Sources', const Color(0xFF22D3EE), LucideIcons.eye)),
          SizedBox(width: context.scaleWidth(10)),
          Expanded(child: _buildStatCard(context, state.categoriesCount.toString(), 'Categories', const Color(0xFFA78BFA), LucideIcons.listFilter)),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: context.scaleHeight(12), horizontal: context.scaleWidth(12)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Container(
            width: context.scaleWidth(28),
            height: context.scaleWidth(28),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: context.scaleWidth(14)),
          ),
          SizedBox(height: context.scaleHeight(8)),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: context.scaleFontSize(14),
              color: Colors.white,
            ),
          ),
          SizedBox(height: context.scaleHeight(2)),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.scaleFontSize(9),
              color: AppColors.silverPlaceholder.withValues(alpha: 0.40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, HotTopicsState state) {
    final prefix = state.activeFilter == HotTopicFilter.all 
        ? 'ALL' 
        : state.activeFilter.name.toUpperCase();
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(24)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$prefix HOT STORIES',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.scaleFontSize(10),
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: AppColors.silverPlaceholder.withValues(alpha: 0.50),
            ),
          ),
          Text(
            '${state.rankedArticles.length} articles',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.scaleFontSize(10),
              color: AppColors.silverPlaceholder.withValues(alpha: 0.30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankedList(BuildContext context, HotTopicsState state) {
    if (state.rankedArticles.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(context.scaleWidth(40)),
          child: Text(
            'No stories found in this category.',
            style: TextStyle(color: AppColors.silverPlaceholder.withValues(alpha: 0.5)),
          ),
        ),
      );
    }

    return Column(
      children: List.generate(state.rankedArticles.length, (index) {
        final article = state.rankedArticles[index];
        final globalRank = (state.activeFilter == HotTopicFilter.all) ? index + 2 : index + 1;

        return PageEntranceAnimation(
          key: ValueKey('ranked_${article.id}'),
          delay: Duration(milliseconds: 250 + ((index > 8 ? 8 : index) * 50)),
          slideOffset: 12.0,
          child: Padding(
            padding: EdgeInsets.only(
              left: context.scaleWidth(20),
              right: context.scaleWidth(20),
              bottom: context.scaleHeight(12),
            ),
            child: _RankedArticleCard(
              article: article,
              rank: globalRank,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEndMarker(BuildContext context) {
    return Column(
      children: [
        Container(
          width: context.scaleWidth(40),
          height: context.scaleHeight(4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: context.scaleHeight(8)),
        Text(
          "You're all caught up",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.scaleFontSize(10),
            color: AppColors.silverPlaceholder.withValues(alpha: 0.25),
          ),
        ),
      ],
    );
  }
}

class _PingDot extends StatefulWidget {
  @override
  _PingDotState createState() => _PingDotState();
}

class _PingDotState extends State<_PingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: context.scaleWidth(8),
              height: context.scaleWidth(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF97316).withValues(alpha: 0.4 + (0.6 * (1.0 - _controller.value))),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: context.scaleWidth(16) * _controller.value,
              height: context.scaleWidth(16) * _controller.value,
              decoration: BoxDecoration(
                color: const Color(0xFFF97316).withValues(alpha: 0.4 * (1.0 - _controller.value)),
                shape: BoxShape.circle,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DotSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(6)),
      child: Container(
        width: context.scaleWidth(2),
        height: context.scaleWidth(2),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _RankedArticleCard extends StatelessWidget {
  final NewsArticle article;
  final int rank;

  const _RankedArticleCard({
    required this.article,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTop3 = rank <= 3;
    final thumbSize = context.scaleWidth(90);

    return PressScaleAnimation(
      onTap: () => context.push('/article/${article.id}'),
      child: Container(
        padding: EdgeInsets.all(context.scaleWidth(12)),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: thumbSize,
                  height: thumbSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    color: AppColors.secondarySurface,
                    image: article.thumbnailUrl != null
                        ? DecorationImage(
                            image: CachedNetworkImageProvider(article.thumbnailUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
                Positioned(
                  top: context.scaleWidth(-6),
                  left: context.scaleWidth(-6),
                  child: Container(
                    width: context.scaleWidth(20),
                    height: context.scaleWidth(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF97316).withValues(alpha: isTop3 ? 0.40 : 0.25),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFF97316).withValues(alpha: isTop3 ? 0.60 : 0.40),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      rank.toString(),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: context.scaleFontSize(10),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (article.trendingScore >= 9.0)
                  Positioned(
                    bottom: context.scaleWidth(-4),
                    right: context.scaleWidth(-4),
                    child: Container(
                      width: context.scaleWidth(22),
                      height: context.scaleWidth(22),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF97316),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF97316).withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        LucideIcons.flame,
                        color: Colors.white,
                        size: context.scaleWidth(12),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: context.scaleWidth(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          article.category.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.scaleFontSize(11),
                            color: const Color(0xFFFB923C),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (article.trendingScore >= 9.0) ...[
                        SizedBox(width: context.scaleWidth(6)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(4), vertical: context.scaleHeight(2)),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF97316).withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFFF97316).withValues(alpha: 0.20)),
                          ),
                          child: Row(
                            children: [
                              Icon(LucideIcons.trendingUp, color: const Color(0xFFFB923C), size: context.scaleWidth(8)),
                              SizedBox(width: context.scaleWidth(2)),
                              Text(
                                'HOT',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: context.scaleFontSize(8),
                                  color: const Color(0xFFFB923C),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: context.scaleHeight(4)),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Newsreader',
                      fontSize: context.scaleFontSize(14),
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(8)),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          article.source,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.scaleFontSize(10),
                            color: AppColors.silverPlaceholder.withValues(alpha: 0.50),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _DotSeparator(),
                      Icon(LucideIcons.clock, color: AppColors.silverPlaceholder.withValues(alpha: 0.30), size: context.scaleWidth(10)),
                      SizedBox(width: context.scaleWidth(2)),
                      Text(
                        article.timeAgo,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.scaleFontSize(10),
                          color: AppColors.silverPlaceholder.withValues(alpha: 0.30),
                        ),
                      ),
                      _DotSeparator(),
                      Icon(LucideIcons.eye, color: AppColors.silverPlaceholder.withValues(alpha: 0.30), size: context.scaleWidth(10)),
                      SizedBox(width: context.scaleWidth(2)),
                      Text(
                        _formatViewsCount(article.trendingScore),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.scaleFontSize(10),
                          color: AppColors.silverPlaceholder.withValues(alpha: 0.30),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: context.scaleWidth(8)),
            SizedBox(
              height: thumbSize,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(context, LucideIcons.bookmark, AppColors.silverPlaceholder.withValues(alpha: 0.50)),
                  _buildActionButton(context, LucideIcons.share2, AppColors.silverPlaceholder.withValues(alpha: 0.25)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, Color iconColor) {
    return Container(
      width: context.scaleWidth(32),
      height: context.scaleWidth(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        color: iconColor,
        size: context.scaleWidth(14),
      ),
    );
  }
}
