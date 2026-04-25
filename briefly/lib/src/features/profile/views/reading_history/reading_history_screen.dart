import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_animations.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../domain/repositories/news_repository.dart';
import '../../cubits/reading_history/reading_history_cubit.dart';
import '../../cubits/reading_history/reading_history_state.dart';
import '../../../auth/presentation/widgets/auth_back_button.dart';
import '../../../home/presentation/widgets/article_card.dart';

class ReadingHistoryScreen extends StatelessWidget {
  const ReadingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReadingHistoryCubit(context.read<NewsRepository>())..loadHistory(),
      child: const _ReadingHistoryView(),
    );
  }
}

class _ReadingHistoryView extends StatelessWidget {
  const _ReadingHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // â”€â”€ Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.scaleWidth(20),
                vertical: context.scaleHeight(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AuthBackButton(onTap: () => context.pop()),
                  ),
                  Text(
                    'Reading History',
                    style: AppTextStyles.h2(
                      context,
                    ).copyWith(fontSize: context.scaleFontSize(18)),
                  ),
                ],
              ),
            ),

            // â”€â”€ Content â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Expanded(
              child: BlocBuilder<ReadingHistoryCubit, ReadingHistoryState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryAccent,
                      ),
                    );
                  }

                  if (state.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  if (state.status == ReadingHistoryStatus.error) {
                    return Center(
                      child: Text(
                        state.errorMessage ?? 'An error occurred',
                        style: AppTextStyles.error(context),
                      ),
                    );
                  }

                  final sections = state.groupedHistory.keys.toList();

                  return PageEntranceAnimation(
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        top: context.scaleHeight(8),
                        bottom: context.scaleHeight(100), // footer clearance
                      ),
                      itemCount: sections.length,
                      itemBuilder: (context, index) {
                        final section = sections[index];
                        final articles = state.groupedHistory[section]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section Label
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                context.scaleWidth(20),
                                context.scaleHeight(24),
                                context.scaleWidth(20),
                                context.scaleHeight(16),
                              ),
                              child: Text(
                                _getSectionTitle(section),
                                style: AppTextStyles.sectionLabel(context),
                              ),
                            ),

                            // Articles in Section
                            StaggeredListAnimation(
                              children: articles.map((article) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    context.scaleWidth(20),
                                    0,
                                    context.scaleWidth(20),
                                    context.scaleHeight(16),
                                  ),
                                  child: ArticleCard(
                                    title: article.title,
                                    category: article.category,
                                    source: article.source,
                                    timeAgo: article.timeAgo,
                                    thumbnailUrl: article.thumbnailUrl,
                                    onTap: () {
                                      context.push('/article/${article.id}');
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSectionTitle(HistorySection section) {
    switch (section) {
      case HistorySection.today:
        return 'TODAY';
      case HistorySection.yesterday:
        return 'YESTERDAY';
      case HistorySection.earlier:
        return 'EARLIER';
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(context.scaleWidth(24)),
            decoration: BoxDecoration(
              color: AppColors.silver08,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history_outlined,
              size: context.scaleWidth(42),
              color: AppColors.silverPlaceholder,
            ),
          ),
          SizedBox(height: context.scaleHeight(24)),
          Text('No History Yet', style: AppTextStyles.h2(context)),
          SizedBox(height: context.scaleHeight(12)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(40)),
            child: Text(
              'Articles you read will show up here so you can easily find them later.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body(context).copyWith(
                fontSize: context.scaleFontSize(14),
                color: AppColors.silverSecondaryLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
