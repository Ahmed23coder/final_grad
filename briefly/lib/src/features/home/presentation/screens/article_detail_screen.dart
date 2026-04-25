import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../domain/models/news_article.dart';
import '../../../../domain/repositories/news_repository.dart';
import '../../cubits/article_cubit.dart';
import '../../cubits/article_state.dart';
class ArticleDetailScreen extends StatelessWidget {
  final String id;
  final NewsArticle? article;

  const ArticleDetailScreen({super.key, required this.id, this.article});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ArticleCubit(context.read<NewsRepository>())..loadArticle(id, initialArticle: article),
      child: const _ArticleDetailView(),
    );
  }
}

class _ArticleDetailView extends StatefulWidget {
  const _ArticleDetailView();

  @override
  State<_ArticleDetailView> createState() => _ArticleDetailViewState();
}

class _ArticleDetailViewState extends State<_ArticleDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ArticleCubit, ArticleState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null || state.article == null) {
            return Center(
              child: Text(
                'Article not found',
                style: AppTextStyles.error(context),
              ),
            );
          }

          final article = state.article!;
          // Split directly by double newline
          final paragraphs = article.content.split('\n\n');

          return Stack(
            children: [
              // 1. Scrollable Content
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scaleWidth(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top clearance for status bar + top nav + spacing
                      SizedBox(
                        height:
                            MediaQuery.paddingOf(context).top +
                            context.scaleHeight(80),
                      ),

                      // Hero Image
                      Container(
                        height: context.scaleHeight(260),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(60),
                            bottomRight: Radius.circular(60),
                          ),
                          color: AppColors.secondarySurface,
                          image: article.thumbnailUrl != null
                              ? DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    article.thumbnailUrl!,
                                  ),
                                  fit: BoxFit.cover,
                                  onError: (_, __) {},
                                )
                              : null,
                        ),
                        child: article.thumbnailUrl == null
                            ? Icon(
                                LucideIcons.image400,
                                color: AppColors.silverPlaceholder,
                                size: context.scaleWidth(48),
                              )
                            : null,
                      ),

                      SizedBox(height: context.scaleHeight(24)),

                      // Metadata Pills Row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            _MetaPill(text: article.source),
                            SizedBox(width: context.scaleWidth(8)),
                            _MetaPill(text: article.timeAgo),
                            SizedBox(width: context.scaleWidth(8)),
                            _MetaPill(text: article.category.toUpperCase()),
                          ],
                        ),
                      ),

                      SizedBox(height: context.scaleHeight(24)),

                      // Headline
                      Text(
                        article.title,
                        style: AppTextStyles.h1(context).copyWith(
                          fontSize: context.scaleFontSize(26),
                          height: 1.25,
                        ),
                      ),

                      SizedBox(height: context.scaleHeight(12)),

                      // Byline
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'By ${article.source}',
                          style: AppTextStyles.caption(context).copyWith(
                            color: AppColors.silverSecondaryLabel, // silver
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      SizedBox(height: context.scaleHeight(32)),

                      // AI Summary Card (if available)
                      if (state.aiSummary != null)
                        Container(
                          margin: EdgeInsets.only(bottom: context.scaleHeight(32)),
                          padding: EdgeInsets.all(context.scaleWidth(20)),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.accentBlue.withValues(alpha: 0.15),
                                AppColors.primaryAccent.withValues(alpha: 0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.accentBlue.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    LucideIcons.sparkles,
                                    color: AppColors.accentBlue,
                                    size: context.scaleWidth(18),
                                  ),
                                  SizedBox(width: context.scaleWidth(8)),
                                  Text(
                                    'AI KEY HIGHLIGHTS',
                                    style: AppTextStyles.buttonLabel(context).copyWith(
                                      color: AppColors.accentBlue,
                                      letterSpacing: 1.2,
                                      fontSize: context.scaleFontSize(12),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: context.scaleHeight(16)),
                              Text(
                                state.aiSummary!,
                                style: AppTextStyles.body(context).copyWith(
                                  height: 1.6,
                                  fontSize: context.scaleFontSize(15),
                                  color: AppColors.foreground,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Article Body Paragraphs
                      if (paragraphs.isNotEmpty)
                        ...paragraphs.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final text = entry.value;

                          // Evaluate Reading State
                          bool isCurrent =
                              state.isReadingAloud &&
                              idx == state.currentParagraphIndex;
                          bool isPast =
                              state.isReadingAloud &&
                              idx < state.currentParagraphIndex;

                          // Default colors
                          Color textColor = AppColors.bodyText;
                          Color bgColor = Colors.transparent;
                          Border? leftBorder;

                          if (state.isReadingAloud) {
                            if (isCurrent) {
                              textColor = AppColors.foreground; // white
                              bgColor = AppColors.accentBlue.withValues(
                                alpha: 0.08,
                              );
                              leftBorder = Border(
                                left: BorderSide(
                                  color: AppColors.accentBlue,
                                  width: 2,
                                ),
                              );
                            } else if (isPast) {
                              textColor = AppColors.bodyText.withValues(
                                alpha: 0.4,
                              );
                            }
                          }

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.only(
                              bottom: context.scaleHeight(24),
                            ),
                            padding: isCurrent
                                ? EdgeInsets.all(context.scaleWidth(16))
                                : EdgeInsets.zero,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: isCurrent
                                  ? BorderRadius.circular(16)
                                  : BorderRadius.zero,
                              border: leftBorder,
                            ),
                            child: Text(
                              text.trim(),
                              style: AppTextStyles.body(context).copyWith(
                                color: textColor,
                                fontSize: context.scaleFontSize(16),
                                height: 1.6,
                              ),
                            ),
                          );
                        }),

                      // Bottom padding clearance for floating elements
                      SizedBox(height: context.scaleHeight(176)), // pb-44
                    ],
                  ),
                ),
              ),

              // 2. Floating Top Navigation Bar
              Positioned(
                top:
                    MediaQuery.of(context).padding.top +
                    context.scaleHeight(14),
                left: context.scaleWidth(16),
                right: context.scaleWidth(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 24,
                      sigmaY: 24,
                    ), // backdrop-blur-2xl
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaleWidth(8),
                        vertical: context.scaleHeight(8),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background.withValues(
                          alpha: 0.8,
                        ), // bg-[#102A43]/80
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.foreground.withValues(
                            alpha: 0.08,
                          ), // border-white/8
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left: Back Arrow
                          _TopBarButton(
                            icon: LucideIcons.arrowLeft,
                            onTap: () => context.pop(),
                            isCircle: true,
                          ),
                          // Right: Actions
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _TopBarButton(
                                icon: state.isReadingAloud
                                    ? LucideIcons.square
                                    : LucideIcons.volume2,
                                label: state.isReadingAloud ? 'Stop' : 'Listen',
                                isActive: state.isReadingAloud,
                                activeColor: AppColors.accentBlue,
                                onTap: () => context
                                    .read<ArticleCubit>()
                                    .toggleReadAloud(),
                              ),
                              SizedBox(width: context.scaleWidth(8)),
                              _TopBarButton(
                                icon: LucideIcons.bookmark,
                                label: state.isSaved ? 'Saved' : 'Save',
                                isActive: state.isSaved,
                                activeColor: AppColors.primaryAccent,
                                onTap: () =>
                                    context.read<ArticleCubit>().toggleSaved(),
                              ),
                              SizedBox(width: context.scaleWidth(8)),
                              _TopBarButton(
                                icon: LucideIcons.share,
                                isCircle: true,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Floating Bottom Areas

              // Audio Player
              if (state.isReadingAloud)
                Positioned(
                  bottom: context.scaleHeight(20),
                  left: context.scaleWidth(16),
                  right: context.scaleWidth(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF0D2137,
                          ).withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.foreground.withValues(alpha: 0.1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Progress bar at top
                            Container(
                              height: 3,
                              width: double.infinity,
                              color: AppColors.foreground.withValues(
                                alpha: 0.05,
                              ),
                              alignment: Alignment.centerLeft,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: 3,
                                width: paragraphs.isNotEmpty
                                    ? (context.screenWidth -
                                              context.scaleWidth(32)) *
                                          ((state.currentParagraphIndex + 1) /
                                              paragraphs.length)
                                    : 0,
                                color: AppColors.accentBlue,
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.scaleWidth(20),
                                vertical: context.scaleHeight(16),
                              ),
                              child: Column(
                                children: [
                                  // Info Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(
                                              context.scaleWidth(6),
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.accentBlue
                                                  .withValues(alpha: 0.2),
                                            ),
                                            child: Icon(
                                              LucideIcons.volume2,
                                              color: AppColors.accentBlue,
                                              size: context.scaleWidth(14),
                                            ),
                                          ),
                                          SizedBox(
                                            width: context.scaleWidth(12),
                                          ),
                                          Text(
                                            'Reading paragraph ${state.currentParagraphIndex + 1} of ${paragraphs.length}',
                                            style:
                                                AppTextStyles.caption(
                                                  context,
                                                ).copyWith(
                                                  color: AppColors
                                                      .silverSecondaryLabel,
                                                ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () => context
                                            .read<ArticleCubit>()
                                            .closeReadAloud(),
                                        child: Icon(
                                          LucideIcons.x,
                                          color: AppColors.silverPlaceholder,
                                          size: context.scaleWidth(18),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: context.scaleHeight(20)),

                                  // Controls Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Speed block
                                      GestureDetector(
                                        onTap: () => context
                                            .read<ArticleCubit>()
                                            .cycleSpeed(),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: context.scaleWidth(12),
                                            vertical: context.scaleHeight(6),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                            color: AppColors.foreground
                                                .withValues(alpha: 0.05),
                                          ),
                                          child: Text(
                                            '${state.playbackSpeed.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), 'x').replaceAll(RegExp(r'0$'), '')}x',
                                            style:
                                                AppTextStyles.buttonLabel(
                                                  context,
                                                ).copyWith(
                                                  fontSize: context
                                                      .scaleFontSize(11),
                                                ),
                                          ),
                                        ),
                                      ),

                                      // Skip/Play block
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () => context
                                                .read<ArticleCubit>()
                                                .previousParagraph(),
                                            child: Icon(
                                              LucideIcons.skipBack,
                                              color: AppColors.foreground,
                                              size: context.scaleWidth(24),
                                            ),
                                          ),
                                          SizedBox(
                                            width: context.scaleWidth(24),
                                          ),
                                          GestureDetector(
                                            onTap: () => context
                                                .read<ArticleCubit>()
                                                .togglePlayPause(),
                                            child: Container(
                                              padding: EdgeInsets.all(
                                                context.scaleWidth(16),
                                              ),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.accentBlue,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.accentBlue
                                                        .withValues(alpha: 0.4),
                                                    blurRadius: 12,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                state.isPlaying
                                                    ? LucideIcons.pause
                                                    : LucideIcons.play,
                                                color: Colors.white,
                                                size: context.scaleWidth(20),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: context.scaleWidth(24),
                                          ),
                                          GestureDetector(
                                            onTap: () => context
                                                .read<ArticleCubit>()
                                                .nextParagraph(
                                                  paragraphs.length - 1,
                                                ),
                                            child: Icon(
                                              LucideIcons.skipForward,
                                              color: AppColors.foreground,
                                              size: context.scaleWidth(24),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Empty spacer for symmetry
                                      SizedBox(width: context.scaleWidth(40)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // Floating Action Hub
              if (!state.isReadingAloud)
                Positioned(
                  bottom: context.scaleHeight(24), // bottom-6 (~24px)
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                        child: GestureDetector(
                          onTap: () => context.read<ArticleCubit>().summarizeArticle(),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.scaleWidth(20),
                              vertical: context.scaleHeight(14),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.background.withValues(
                                alpha: 0.70,
                              ), // bg-[#102A43]/70
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.scaleWidth(12),
                                vertical: context.scaleHeight(8),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.foreground.withValues(
                                  alpha: 0.08,
                                ), // bg-white/8
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  state.isSummarizing
                                      ? SizedBox(
                                          width: context.scaleWidth(16),
                                          height: context.scaleWidth(16),
                                          child: const CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation(
                                              AppColors.foreground,
                                            ),
                                          ),
                                        )
                                      : Icon(
                                          LucideIcons.sparkles,
                                          color: AppColors.foreground,
                                          size: context.scaleWidth(16),
                                        ),
                                  SizedBox(width: context.scaleWidth(8)),
                                  Text(
                                    state.isSummarizing
                                        ? 'Summarizing...'
                                        : 'Summarize with AI',
                                    style: AppTextStyles.buttonLabel(context)
                                        .copyWith(
                                          fontSize: context.scaleFontSize(14),
                                          color: AppColors.foreground,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TopBarButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;
  final bool isCircle;
  final bool isActive;
  final Color? activeColor;

  const _TopBarButton({
    required this.icon,
    required this.onTap,
    this.label,
    this.isCircle = false,
    this.isActive = false,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    // Default styling: bg-white/5, border-white/8
    Color bgColor = AppColors.foreground.withValues(alpha: 0.05);
    Color borderColor = AppColors.foreground.withValues(alpha: 0.08);
    Color contentColor = AppColors.foreground;

    if (isActive && activeColor != null) {
      bgColor = activeColor!.withValues(alpha: 0.20); // bg-[#2979FF]/20
      borderColor = activeColor!.withValues(alpha: 0.30);
      contentColor = activeColor!;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: isCircle
            ? EdgeInsets.all(context.scaleWidth(10))
            : EdgeInsets.symmetric(
                horizontal: context.scaleWidth(12),
                vertical: context.scaleHeight(8),
              ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: contentColor, size: context.scaleWidth(16)),
            if (label != null && !isCircle) ...[
              SizedBox(width: context.scaleWidth(6)),
              Text(
                label!,
                style: AppTextStyles.buttonLabel(context).copyWith(
                  fontSize: context.scaleFontSize(12),
                  color: contentColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final String text;

  const _MetaPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleWidth(12),
        vertical: context.scaleHeight(6),
      ),
      decoration: BoxDecoration(
        color: AppColors.foreground.withValues(alpha: 0.05), // bg-white/5
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.foreground.withValues(alpha: 0.08), // border-white/8
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption(context).copyWith(
          color: AppColors.silverSecondaryLabel, // silver text
        ),
      ),
    );
  }
}
