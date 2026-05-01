import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/press_scale_animation.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../core/utils/category_colors.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/ui_feedback.dart';
import '../../../../domain/models/hot_topic_filter.dart';
import '../../../../domain/models/news_article.dart';
import '../../../../domain/repositories/news_repository.dart';
import '../../bloc/home_view/home_bloc.dart';
import '../../bloc/home_view/home_event.dart';
import '../../bloc/home_view/home_state.dart';
import '../../../notifications/cubits/notifications_cubit.dart';
import '../../../notifications/cubits/notifications_state.dart';
import '../widgets/article_card.dart';
import '../widgets/home_skeleton.dart';
import '../widgets/trending_carousel.dart';
import '../../../profile/cubits/profile_cubit.dart';
import '../../../profile/cubits/profile_state.dart';

String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good morning';
  if (hour < 18) return 'Good afternoon';
  return 'Good evening';
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeBloc(context.read<NewsRepository>())..add(LoadHomeFeed()),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(LoadHomeFeed());
          await context.read<HomeBloc>().stream.first;
        },
        color: AppColors.accentBlue,
        backgroundColor: AppColors.background,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: true),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // 1. Sticky Header
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                expandedHeight:
                    MediaQuery.paddingOf(context).top + context.scaleHeight(48),
                toolbarHeight: context.scaleHeight(48),
                backgroundColor: AppColors.background.withValues(alpha: 0.95),
                elevation: 0,
                scrolledUnderElevation: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                centerTitle: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: Hamburger + Logo
                    Row(
                      children: [
                        _CircularIconButton(
                          icon: LucideIcons.menu,
                          onTap: () => Scaffold.of(context).openDrawer(),
                        ),
                        SizedBox(width: context.scaleWidth(12)),
                        Icon(
                          LucideIcons.zap,
                          color: AppColors.foreground,
                          size: context.scaleWidth(20),
                        ),
                        SizedBox(width: context.scaleWidth(6)),
                        Text(
                          'Briefly',
                          style: AppTextStyles.h1(
                            context,
                          ).copyWith(fontSize: context.scaleFontSize(20)),
                        ),
                      ],
                    ),

                    // Right: Bell with Red Dot
                    BlocSelector<NotificationsCubit, NotificationsState, bool>(
                      selector: (state) =>
                          state is NotificationsLoaded && state.unreadCount > 0,
                      builder: (context, hasUnread) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _CircularIconButton(
                              icon: LucideIcons.bell,
                              onTap: () =>
                                  context.push(AppRouter.notifications),
                            ),
                            if (hasUnread)
                              Positioned(
                                top: context.scaleHeight(2),
                                right: context.scaleWidth(2),
                                child: Container(
                                  width: context.scaleWidth(8),
                                  height: context.scaleWidth(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.background,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              // 2. Category Pills Row
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 0,
                    bottom: context.scaleHeight(8),
                  ),
                  child: SizedBox(
                    height: context.scaleHeight(40),
                    child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state.categories.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return ScrollConfiguration(
                          behavior: ScrollConfiguration.of(
                            context,
                          ).copyWith(overscroll: false),
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.scaleWidth(20),
                            ),
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.categories.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(width: context.scaleWidth(8)),
                            itemBuilder: (context, index) {
                              final category = state.categories[index];
                              final isSelected =
                                  category == state.selectedCategory;

                              final bgColor = isSelected
                                  ? const Color(0xFFC0C0C0)
                                  : Colors.transparent;
                              final borderColor = isSelected
                                  ? const Color(0xFFC0C0C0)
                                  : const Color(
                                      0xFFC0C0C0,
                                    ).withValues(alpha: 0.15);
                              final textColor = isSelected
                                  ? AppColors.background
                                  : const Color(
                                      0xFFC0C0C0,
                                    ).withValues(alpha: 0.50);

                              return PressScaleAnimation(
                                key: ValueKey('category_$category'),
                                onTap: () => context.read<HomeBloc>().add(
                                  SelectCategory(category),
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.scaleWidth(16),
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: Text(
                                    category.toUpperCase(),
                                    style: AppTextStyles.buttonLabel(context)
                                        .copyWith(
                                          color: textColor,
                                          fontSize: context.scaleFontSize(11),
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Feed Body Builder
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: HomeSkeleton(),
                    );
                  }
                  if (state.error != null) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Failed to load feed',
                          style: AppTextStyles.error(context),
                        ),
                      ),
                    );
                  }
                  final hasAnyContent =
                      state.featured != null ||
                      state.trending.isNotEmpty ||
                      state.hotTopics.isNotEmpty;
                  if (!hasAnyContent) {
                    return const SliverFillRemaining(child: SizedBox.shrink());
                  }

                  final featuredArticle = state.featured;
                  final carouselArticles = state.trending.take(8).toList();
                  final hotTopicArticles = state.hotTopics.take(5).toList();

                  void saveAndConfirm(NewsArticle a) {
                    context.read<NewsRepository>().saveArticle(a);
                    UiFeedback.showSnack(context, 'Saved to your vault.');
                  }

                    return SliverList(
                      delegate: SliverChildListDelegate([
                        // 2.5 Greeting
                        BlocSelector<ProfileCubit, ProfileState, String>(
                          selector: (s) =>
                              s.profile.name.isNotEmpty
                                  ? s.profile.name
                                  : 'Friend',
                          builder: (context, displayName) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.scaleWidth(20),
                                vertical: context.scaleHeight(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_greeting()}, $displayName',
                                    style: AppTextStyles.h2(context).copyWith(
                                      fontSize: context.scaleFontSize(24),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: context.scaleHeight(4)),
                                  Text(
                                    'Here is your news for today',
                                    style: AppTextStyles.caption(context).copyWith(
                                      color: Colors.white.withValues(alpha: 0.55),
                                      fontSize: context.scaleFontSize(14),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        // 3. Featured Article Card
                      if (featuredArticle != null)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scaleWidth(20),
                          ),
                          child: PressScaleAnimation(
                            key: ValueKey('featured_${featuredArticle.id}'),
                            onTap: () => context.push(
                              '/article/${featuredArticle.id}',
                              extra: featuredArticle,
                            ),
                            child: Container(
                              height: context.scaleHeight(208),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: AppColors.secondarySurface,
                                image: featuredArticle.thumbnailUrl != null
                                    ? DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          featuredArticle.thumbnailUrl!,
                                        ),
                                        fit: BoxFit.cover,
                                        onError: (_, __) {},
                                      )
                                    : null,
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.85),
                                          Colors.black.withValues(alpha: 0.40),
                                          Colors.black.withValues(alpha: 0.10),
                                        ],
                                        stops: const [0.0, 0.4, 1.0],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.scaleWidth(16),
                                      vertical: context.scaleHeight(16),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: context.scaleWidth(10),
                                            vertical: context.scaleHeight(6),
                                          ),
                                          decoration: BoxDecoration(
                                            color: CategoryColors.forCategory(
                                              featuredArticle.category,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          child: Text(
                                            featuredArticle.category
                                                .toUpperCase(),
                                            style:
                                                AppTextStyles.caption(
                                                  context,
                                                ).copyWith(
                                                  color: Colors.white,
                                                  fontSize: context
                                                      .scaleFontSize(10),
                                                  letterSpacing: 0.5,
                                                ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              saveAndConfirm(featuredArticle),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 4,
                                                sigmaY: 4,
                                              ),
                                              child: Container(
                                                width: context.scaleWidth(32),
                                                height: context.scaleWidth(32),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.30),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  LucideIcons.bookmark,
                                                  color: Colors.white,
                                                  size: context.scaleWidth(14),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: context.scaleHeight(16),
                                    left: context.scaleWidth(16),
                                    right: context.scaleWidth(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          featuredArticle.title,
                                          style: AppTextStyles.h1(context)
                                              .copyWith(
                                                fontSize: context.scaleFontSize(
                                                  20,
                                                ),
                                                color: Colors.white,
                                                height: 1.2,
                                              ),
                                        ),
                                        SizedBox(
                                          height: context.scaleHeight(6),
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                featuredArticle.source,
                                                style:
                                                    AppTextStyles.caption(
                                                      context,
                                                    ).copyWith(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.5,
                                                          ),
                                                      fontSize: context
                                                          .scaleFontSize(11),
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: context.scaleWidth(
                                                  6,
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius: 1.5,
                                                backgroundColor: Colors.white
                                                    .withValues(alpha: 0.25),
                                              ),
                                            ),
                                            Text(
                                              featuredArticle.timeAgo,
                                              style:
                                                  AppTextStyles.caption(
                                                    context,
                                                  ).copyWith(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.5),
                                                    fontSize: context
                                                        .scaleFontSize(11),
                                                  ),
                                            ),
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

                      SizedBox(height: context.scaleHeight(24)),

                      // 4. Trending Carousel
                      if (carouselArticles.isNotEmpty)
                        TrendingCarousel(
                          articles: carouselArticles,
                          onArticleTap: (article) => context.push(
                            '/article/${article.id}',
                            extra: article,
                          ),
                        ),

                      SizedBox(height: context.scaleHeight(24)),

                      // 5. Hot Topic Section
                      if (hotTopicArticles.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scaleWidth(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(
                                      context.scaleWidth(6),
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFF97316,
                                      ).withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      LucideIcons.flame,
                                      color: const Color(0xFFFB923C),
                                      size: context.scaleWidth(16),
                                    ),
                                  ),
                                  SizedBox(width: context.scaleWidth(8)),
                                  Text(
                                    'Hot Topic',
                                    style: AppTextStyles.h1(context).copyWith(
                                      fontSize: context.scaleFontSize(20),
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              PressScaleAnimation(
                                onTap: () {
                                  context.push(
                                    AppRouter.hotTopics,
                                    extra: HotTopicFilter.all.name,
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'View all',
                                      style: AppTextStyles.caption(
                                        context,
                                      ).copyWith(color: AppColors.accentBlue),
                                    ),
                                    SizedBox(width: context.scaleWidth(4)),
                                    Icon(
                                      LucideIcons.chevronRight,
                                      color: AppColors.accentBlue,
                                      size: context.scaleWidth(14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      SizedBox(height: context.scaleHeight(16)),

                      if (hotTopicArticles.isNotEmpty)
                        ...hotTopicArticles.map(
                          (article) => Padding(
                            padding: EdgeInsets.only(
                              left: context.scaleWidth(20),
                              right: context.scaleWidth(20),
                              bottom: context.scaleHeight(12),
                            ),
                            child: ArticleCard(
                              title: article.title,
                              category: article.category,
                              source: article.source,
                              timeAgo: article.timeAgo,
                              thumbnailUrl: article.thumbnailUrl,
                              isFlat: true,
                              onTap: () {
                                context.push(
                                  '/article/${article.id}',
                                  extra: article,
                                );
                              },
                              onBookmarkTap: () => saveAndConfirm(article),
                            ),
                          ),
                        ),

                      SizedBox(height: context.scaleHeight(96)),
                    ]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircularIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.scaleWidth(8)),
        decoration: BoxDecoration(
          color: AppColors.foreground.withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.foreground,
          size: context.scaleWidth(20),
        ),
      ),
    );
  }
}
