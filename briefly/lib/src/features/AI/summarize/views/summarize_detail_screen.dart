import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/colors/app_colors.dart';
import '../../../core/radius/app_radius.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../core/utils/app_animations.dart';
import '../../../core/utils/responsive_util.dart';
import '../cubits/summarize_detail_cubit.dart';
import '../cubits/summarize_detail_state.dart';

/// AI Summarize Detail â€” article-specific summary accessed from Article Detail.
class SummarizeDetailScreen extends StatelessWidget {
  final String id;

  const SummarizeDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SummarizeDetailCubit(articleId: id),
      child: const _SummarizeDetailView(),
    );
  }
}

class _SummarizeDetailView extends StatelessWidget {
  const _SummarizeDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<SummarizeDetailCubit, SummarizeDetailState>(
        builder: (context, state) {
          return Stack(
            children: [
              // Scrollable content
              Positioned.fill(
                child: state.isLoading
                    ? _LoadingState()
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: MediaQuery.paddingOf(context).top +
                              context.scaleHeight(80),
                          left: context.scaleWidth(20),
                          right: context.scaleWidth(20),
                          bottom: context.scaleHeight(128),
                        ),
                        child: PageEntranceAnimation(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Article Reference Card
                              _ArticleReferenceCard(state: state),

                              SizedBox(height: context.scaleHeight(24)),

                              // Tab Bar
                              _TabBar(state: state),

                              SizedBox(height: context.scaleHeight(20)),

                              // Tab Content
                              _TabContent(state: state),
                            ],
                          ),
                        ),
                      ),
              ),

              // Floating Top Nav
              Positioned(
                top: MediaQuery.paddingOf(context).top +
                    context.scaleHeight(14),
                left: context.scaleWidth(16),
                right: context.scaleWidth(16),
                child: _TopNav(state: state),
              ),
            ],
          );
        },
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// LOADING STATE
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: context.scaleWidth(32),
            height: context.scaleWidth(32),
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.primaryAccent,
            ),
          ),
          SizedBox(height: context.scaleHeight(16)),
          Text(
            'Analyzing articleâ€¦',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: context.scaleFontSize(14),
              color: AppColors.silverSecondaryLabel,
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// TOP NAV â€” floating glass pill
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _TopNav extends StatelessWidget {
  final SummarizeDetailState state;

  const _TopNav({required this.state});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.navPillValue),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.scaleWidth(8),
            vertical: context.scaleHeight(8),
          ),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(AppRadius.navPillValue),
            border: Border.all(
              color: AppColors.foreground.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back
              _NavButton(
                icon: LucideIcons.arrowLeft,
                onTap: () => context.pop(),
                isCircle: true,
              ),
              // Center â€” Title
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.sparkles,
                    size: context.scaleWidth(14),
                    color: AppColors.primaryAccent,
                  ),
                  SizedBox(width: context.scaleWidth(6)),
                  Text(
                    'AI Summary',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: context.scaleFontSize(13),
                      color: AppColors.foreground,
                    ),
                  ),
                ],
              ),
              // Copy
              _NavButton(
                icon: state.hasCopied ? LucideIcons.check : LucideIcons.copy,
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(text: state.summaryText),
                  );
                  context.read<SummarizeDetailCubit>().copyResult();
                },
                isCircle: true,
                iconColor: state.hasCopied
                    ? const Color(0xFF10B981)
                    : AppColors.foreground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isCircle;
  final Color? iconColor;

  const _NavButton({
    required this.icon,
    required this.onTap,
    this.isCircle = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.scaleWidth(10)),
        decoration: BoxDecoration(
          color: AppColors.foreground.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppRadius.navPillValue),
          border: Border.all(
            color: AppColors.foreground.withValues(alpha: 0.08),
          ),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.foreground,
          size: context.scaleWidth(16),
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// ARTICLE REFERENCE CARD
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ArticleReferenceCard extends StatelessWidget {
  final SummarizeDetailState state;

  const _ArticleReferenceCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.scaleWidth(20)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.settingsGroupValue),
        border: Border.all(
          color: AppColors.borderColor,
          width: AppRadius.buttonValue,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quote icon
          Container(
            padding: EdgeInsets.all(context.scaleWidth(8)),
            decoration: BoxDecoration(
              color: AppColors.foreground.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppRadius.cardValue),
            ),
            child: Icon(
              LucideIcons.quote,
              size: context.scaleWidth(16),
              color: AppColors.primaryAccent,
            ),
          ),
          SizedBox(width: context.scaleWidth(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.articleTitle,
                  style: AppTextStyles.cardLabel(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.scaleHeight(6)),
                Text(
                  '${state.articleSource}  Â·  ${state.articleCategory}',
                  style: AppTextStyles.caption(context).copyWith(
                    color: AppColors.silverSecondaryLabel,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// TAB BAR
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _TabBar extends StatelessWidget {
  final SummarizeDetailState state;

  const _TabBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (SummarizeDetailTab.summary, LucideIcons.fileText, 'Summary'),
      (SummarizeDetailTab.keyPoints, LucideIcons.lightbulb, 'Key Points'),
      (SummarizeDetailTab.analysis, LucideIcons.chartBar, 'Analysis'),
    ];

    return Row(
      children: tabs.map((tab) {
        final isActive = state.activeTab == tab.$1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: tab.$1 != SummarizeDetailTab.analysis
                  ? context.scaleWidth(8)
                  : 0,
            ),
            child: PressScaleAnimation(
              onTap: () =>
                  context.read<SummarizeDetailCubit>().setTab(tab.$1),
              scaleOnPress: 0.95,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: context.scaleHeight(42),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primaryAccent
                      : AppColors.card,
                  borderRadius:
                      BorderRadius.circular(AppRadius.pillValue),
                  border: Border.all(
                    color: isActive
                        ? AppColors.primaryAccent
                        : AppColors.borderColor,
                    width: AppRadius.buttonValue,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tab.$2,
                      size: context.scaleWidth(14),
                      color: isActive
                          ? AppColors.primaryForeground
                          : AppColors.mutedForeground,
                    ),
                    SizedBox(width: context.scaleWidth(6)),
                    Text(
                      tab.$3,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: context.scaleFontSize(11),
                        color: isActive
                            ? AppColors.primaryForeground
                            : AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// TAB CONTENT
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _TabContent extends StatelessWidget {
  final SummarizeDetailState state;

  const _TabContent({required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state.activeTab) {
      case SummarizeDetailTab.summary:
        return _SummaryTab(state: state);
      case SummarizeDetailTab.keyPoints:
        return _KeyPointsTab(state: state);
      case SummarizeDetailTab.analysis:
        return _AnalysisTab(state: state);
    }
  }
}

// â”€â”€ SUMMARY TAB â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SummaryTab extends StatelessWidget {
  final SummarizeDetailState state;

  const _SummaryTab({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          state.summaryText,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: context.scaleFontSize(14),
            height: 1.7,
            color: AppColors.bodyText,
          ),
        ),
        SizedBox(height: context.scaleHeight(20)),
        // Disclaimer pill
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.scaleWidth(16),
            vertical: context.scaleHeight(10),
          ),
          decoration: BoxDecoration(
            color: AppColors.foreground.withValues(alpha: 0.05),
            borderRadius:
                BorderRadius.circular(AppRadius.pillValue),
            border: Border.all(
              color: AppColors.foreground.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.info,
                size: context.scaleWidth(14),
                color: AppColors.silverTimestamp,
              ),
              SizedBox(width: context.scaleWidth(8)),
              Expanded(
                child: Text(
                  'AI-generated summary. Verify critical information with the original source.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: context.scaleFontSize(10),
                    color: AppColors.silverTimestamp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// â”€â”€ KEY POINTS TAB â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _KeyPointsTab extends StatelessWidget {
  final SummarizeDetailState state;

  const _KeyPointsTab({required this.state});

  @override
  Widget build(BuildContext context) {
    return StaggeredListAnimation(
      itemDelay: const Duration(milliseconds: 80),
      children: state.keyPoints.asMap().entries.map((entry) {
        return _KeyPointCard(
          index: entry.key + 1,
          text: entry.value,
        );
      }).toList(),
    );
  }
}

class _KeyPointCard extends StatelessWidget {
  final int index;
  final String text;

  const _KeyPointCard({required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: context.scaleHeight(10)),
      padding: EdgeInsets.all(context.scaleWidth(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.cardValue),
        border: Border.all(
          color: AppColors.borderColor,
          width: AppRadius.buttonValue,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.scaleWidth(28),
            height: context.scaleWidth(28),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.foreground.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.pillValue),
            ),
            child: Text(
              '$index',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: context.scaleFontSize(12),
                color: AppColors.primaryAccent,
              ),
            ),
          ),
          SizedBox(width: context.scaleWidth(12)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: context.scaleFontSize(13),
                height: 1.5,
                color: AppColors.bodyText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€ ANALYSIS TAB â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _AnalysisTab extends StatelessWidget {
  final SummarizeDetailState state;

  const _AnalysisTab({required this.state});

  @override
  Widget build(BuildContext context) {
    return StaggeredListAnimation(
      itemDelay: const Duration(milliseconds: 60),
      children: state.analysisMetrics.entries.map((entry) {
        return _MetricRow(label: entry.key, value: entry.value);
      }).toList(),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: context.scaleHeight(8)),
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleWidth(16),
        vertical: context.scaleHeight(14),
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.cardValue),
        border: Border.all(
          color: AppColors.borderColor,
          width: AppRadius.buttonValue,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: context.scaleFontSize(13),
              color: AppColors.silverSecondaryLabel,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: context.scaleFontSize(13),
              color: AppColors.foreground,
            ),
          ),
        ],
      ),
    );
  }
}


