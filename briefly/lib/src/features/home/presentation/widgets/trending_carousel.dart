import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/category_colors.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../core/widgets/press_scale_animation.dart';
import '../../../../domain/models/news_article.dart';

/// Horizontally-scrollable trending carousel with a thin progress indicator
/// underneath. The indicator shows the user's scroll position so they know
/// there's more off-screen — useful when there are >3 items.
class TrendingCarousel extends StatefulWidget {
  final List<NewsArticle> articles;
  final void Function(NewsArticle) onArticleTap;

  const TrendingCarousel({
    super.key,
    required this.articles,
    required this.onArticleTap,
  });

  @override
  State<TrendingCarousel> createState() => _TrendingCarouselState();
}

class _TrendingCarouselState extends State<TrendingCarousel> {
  late final ScrollController _ctrl;
  // 0..1 fraction representing how far through the list we've scrolled.
  final ValueNotifier<double> _progress = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _ctrl = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_ctrl.hasClients) return;
    final max = _ctrl.position.maxScrollExtent;
    if (max <= 0) {
      _progress.value = 0;
      return;
    }
    _progress.value = (_ctrl.offset / max).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _ctrl
      ..removeListener(_onScroll)
      ..dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.articles.isEmpty) return const SizedBox.shrink();

    final cardWidth = context.scaleWidth(160);
    final thumbHeight = context.scaleHeight(110);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: thumbHeight + context.scaleHeight(96),
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(overscroll: false),
            child: ListView.separated(
              controller: _ctrl,
              padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(20)),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.articles.length,
              separatorBuilder: (_, __) =>
                  SizedBox(width: context.scaleWidth(12)),
              itemBuilder: (context, index) {
                final article = widget.articles[index];
                return _CarouselCard(
                  article: article,
                  width: cardWidth,
                  thumbHeight: thumbHeight,
                  onTap: () => widget.onArticleTap(article),
                );
              },
            ),
          ),
        ),
        // Progress track — only meaningful when content overflows.
        if (widget.articles.length > 2) ...[
          SizedBox(height: context.scaleHeight(12)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(20)),
            child: ValueListenableBuilder<double>(
              valueListenable: _progress,
              builder: (_, p, __) => _ProgressTrack(progress: p),
            ),
          ),
        ],
      ],
    );
  }
}

class _CarouselCard extends StatelessWidget {
  final NewsArticle article;
  final double width;
  final double thumbHeight;
  final VoidCallback onTap;

  const _CarouselCard({
    required this.article,
    required this.width,
    required this.thumbHeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: thumbHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
                color: AppColors.secondarySurface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                image: article.thumbnailUrl != null
                    ? DecorationImage(
                        image:
                            CachedNetworkImageProvider(article.thumbnailUrl!),
                        fit: BoxFit.cover,
                        onError: (_, __) {},
                      )
                    : null,
              ),
            ),
            SizedBox(height: context.scaleHeight(8)),
            Text(
              article.title,
              style: AppTextStyles.h2(context).copyWith(
                fontSize: context.scaleFontSize(13),
                color: Colors.white,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: context.scaleHeight(6)),
            Row(
              children: [
                Flexible(
                  child: Text(
                    article.source,
                    style: AppTextStyles.caption(context).copyWith(
                      color: CategoryColors.forCategory(article.category),
                      fontSize: context.scaleFontSize(10),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: context.scaleWidth(4)),
                  child: CircleAvatar(
                    radius: 1,
                    backgroundColor:
                        AppColors.silverPlaceholder.withValues(alpha: 0.3),
                  ),
                ),
                Flexible(
                  child: Text(
                    article.timeAgo,
                    style: AppTextStyles.caption(context).copyWith(
                      color:
                          AppColors.silverPlaceholder.withValues(alpha: 0.4),
                      fontSize: context.scaleFontSize(10),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressTrack extends StatelessWidget {
  final double progress;
  const _ProgressTrack({required this.progress});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const trackHeight = 3.0;
        final fullWidth = constraints.maxWidth;
        // Thumb is ~30% of track width — visually obvious without taking
        // over the whole bar.
        final thumbWidth = fullWidth * 0.3;
        final maxOffset = fullWidth - thumbWidth;

        return Stack(
          children: [
            Container(
              height: trackHeight,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(trackHeight),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              left: maxOffset * progress,
              child: Container(
                height: trackHeight,
                width: thumbWidth,
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(trackHeight),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
