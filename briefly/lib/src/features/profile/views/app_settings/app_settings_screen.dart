import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/theme/app_text_styles.dart';
import 'package:briefly/src/core/theme/app_radius.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';
import 'package:briefly/src/core/utils/app_animations.dart';

import '../../cubits/app_settings/app_settings_cubit.dart';
import '../../cubits/app_settings/app_settings_state.dart';

import '../../widget/app_settings/settings_row.dart';
import '../../widget/app_settings/settings_toggle.dart';
import '../../widget/app_settings/option_picker.dart';
import '../../widget/app_settings/cache_card.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: context.scaleWidth(20),
                      right: context.scaleWidth(20),
                      bottom: context.scaleHeight(40),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: context.scaleHeight(10)),
                        
                        // Section A - Appearance
                        _buildSectionHeader(context, 'APPEARANCE'),
                        PageEntranceAnimation(
                          delay: const Duration(seconds: 0),
                          slideOffset: 10.0,
                          child: _buildGroupCard([
                            SettingsRow(
                              icon: LucideIcons.moon,
                              iconColor: AppColors.accentBlue,
                              label: 'Dark Mode',
                              trailing: SettingsToggle(
                                value: state.darkMode,
                                onChanged: (v) => context.read<AppSettingsCubit>().toggleDarkMode(v),
                              ),
                            ),
                            SettingsRow(
                              icon: LucideIcons.layoutGrid,
                              iconColor: const Color(0xFFC0C0C0),
                              label: 'Compact Mode',
                              subLabel: 'Optimised for high-density reading',
                              trailing: SettingsToggle(
                                value: state.compactMode,
                                onChanged: (v) => context.read<AppSettingsCubit>().toggleCompactMode(v),
                              ),
                            ),
                            SettingsRow(
                              icon: LucideIcons.image,
                              iconColor: const Color(0xFFC0C0C0),
                              label: 'Show Article Images',
                              trailing: SettingsToggle(
                                value: state.showArticleImages,
                                onChanged: (v) => context.read<AppSettingsCubit>().toggleShowArticleImages(v),
                              ),
                            ),
                          ]),
                        ),

                        SizedBox(height: context.scaleHeight(24)),

                        // Section B - Reading Font Size
                        _buildSectionHeader(context, 'READING FONT SIZE'),
                        PageEntranceAnimation(
                          delay: const Duration(milliseconds: 50),
                          slideOffset: 10.0,
                          child: _buildGroupCard([
                             Padding(
                               padding: EdgeInsets.all(context.scaleWidth(16)),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Text('Aa', style: AppTextStyles.body(context).copyWith(fontSize: context.scaleFontSize(12), color: AppColors.silverSecondaryLabel)),
                                       Container(width: 1, height: 12, color: AppColors.silverBorder),
                                       Text('Aa', style: AppTextStyles.body(context).copyWith(fontSize: context.scaleFontSize(20), color: AppColors.foreground)),
                                     ],
                                   ),
                                   SizedBox(height: context.scaleHeight(16)),
                                   OptionPicker<AppFontSize>(
                                     options: AppFontSize.values,
                                     selected: state.fontSize,
                                     onSelected: (v) => context.read<AppSettingsCubit>().updateFontSize(v),
                                     labelBuilder: (v) => v.name.toUpperCase().replaceAll('SIZE', ''),
                                   ),
                                 ],
                               ),
                             ),
                          ]),
                        ),

                        SizedBox(height: context.scaleHeight(24)),

                        // Section C - Notifications
                        _buildSectionHeader(context, 'NOTIFICATIONS'),
                        PageEntranceAnimation(
                          delay: const Duration(milliseconds: 80),
                          slideOffset: 10.0,
                          child: _buildGroupCard([
                            SettingsRow(
                              icon: LucideIcons.bellRing,
                              iconColor: const Color(0xFFFF9500),
                              label: 'Breaking News Alerts',
                              trailing: SettingsToggle(
                                value: state.breakingNewsAlerts,
                                onChanged: (v) => context.read<AppSettingsCubit>().toggleBreakingNewsAlerts(v),
                              ),
                            ),
                            SettingsRow(
                              icon: LucideIcons.mail,
                              iconColor: const Color(0xFF5AC8FA),
                              label: 'Daily Digest',
                              trailing: SettingsToggle(
                                value: state.dailyDigest,
                                onChanged: (v) => context.read<AppSettingsCubit>().toggleDailyDigest(v),
                              ),
                            ),
                            SettingsRow(
                              icon: LucideIcons.calendarCheck,
                              iconColor: const Color(0xFFC0C0C0),
                              label: 'Weekly Recap',
                              trailing: SettingsToggle(
                                value: state.weeklyRecap,
                                onChanged: (v) => context.read<AppSettingsCubit>().toggleWeeklyRecap(v),
                              ),
                            ),
                            SettingsRow(
                              icon: LucideIcons.volume2,
                              iconColor: const Color(0xFFC0C0C0),
                              label: 'Sound Effects',
                              trailing: SettingsToggle(
                                value: state.soundEffects,
                                onChanged: (v) => context.read<AppSettingsCubit>().toggleSoundEffects(v),
                              ),
                            ),
                          ]),
                        ),

                        SizedBox(height: context.scaleHeight(24)),

                        // Section D - Language & Region
                        _buildSectionHeader(context, 'LANGUAGE & REGION'),
                        PageEntranceAnimation(
                          delay: const Duration(milliseconds: 100),
                          slideOffset: 10.0,
                          child: _buildGroupCard([
                            SettingsRow(
                              icon: LucideIcons.globe,
                              iconColor: const Color(0xFFC0C0C0),
                              label: 'App Language',
                              subLabel: 'Selection will restart the app',
                            ),
                             Padding(
                               padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(16), vertical: context.scaleHeight(12)),
                               child: OptionPicker<AppLanguage>(
                                 options: AppLanguage.values,
                                 selected: state.language,
                                 onSelected: (v) => context.read<AppSettingsCubit>().updateLanguage(v),
                                 labelBuilder: (v) => v.name[0].toUpperCase() + v.name.substring(1),
                               ),
                             ),
                          ]),
                        ),

                        SizedBox(height: context.scaleHeight(24)),

                        // Section E - Content & Feed
                        _buildSectionHeader(context, 'CONTENT & FEED'),
                        PageEntranceAnimation(
                          delay: const Duration(milliseconds: 120),
                          slideOffset: 10.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGroupCard([
                                SettingsRow(
                                  icon: LucideIcons.circlePlay,
                                  iconColor: const Color(0xFFC0C0C0),
                                  label: 'Auto-play Videos',
                                  trailing: SettingsToggle(
                                    value: state.autoPlayVideos,
                                    onChanged: (v) => context.read<AppSettingsCubit>().toggleAutoPlayVideos(v),
                                  ),
                                ),
                                SettingsRow(
                                  icon: LucideIcons.externalLink,
                                  iconColor: const Color(0xFFC0C0C0),
                                  label: 'Open Links In-App',
                                  trailing: SettingsToggle(
                                    value: state.openLinksInApp,
                                    onChanged: (v) => context.read<AppSettingsCubit>().toggleOpenLinksInApp(v),
                                  ),
                                ),
                                SettingsRow(
                                  icon: LucideIcons.refreshCw,
                                  iconColor: const Color(0xFFC0C0C0),
                                  label: 'Feed Refresh Rate',
                                  subLabel: 'Check for updates periodically',
                                  onTap: () {}, // Chevron trailing automatically added
                                ),
                              ]),
                              SizedBox(height: context.scaleHeight(12)),
                              _buildGroupCard([
                                Padding(
                                  padding: EdgeInsets.all(context.scaleWidth(16)),
                                  child: OptionPicker<FeedRefreshRate>(
                                    options: FeedRefreshRate.values,
                                    selected: state.refreshRate,
                                    onSelected: (v) => context.read<AppSettingsCubit>().updateRefreshRate(v),
                                    labelBuilder: (v) {
                                      switch(v) {
                                        case FeedRefreshRate.fiveMin: return '5 MIN';
                                        case FeedRefreshRate.fifteenMin: return '15 MIN';
                                        case FeedRefreshRate.thirtyMin: return '30 MIN';
                                        case FeedRefreshRate.hourly: return 'HOURLY';
                                        case FeedRefreshRate.manual: return 'MANUAL';
                                      }
                                    },
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),

                        SizedBox(height: context.scaleHeight(24)),

                        // Section F - Data & Storage
                        _buildSectionHeader(context, 'DATA & STORAGE'),
                        PageEntranceAnimation(
                          delay: const Duration(milliseconds: 150),
                          slideOffset: 10.0,
                          child: _buildGroupCard([
                            SettingsRow(
                              icon: LucideIcons.wifi,
                              iconColor: const Color(0xFFC0C0C0),
                              label: 'Wi-Fi Only Media',
                              trailing: SettingsToggle(
                                value: state.wifiOnlyMedia,
                                onChanged: (v) => context.read<AppSettingsCubit>().toggleWifiOnlyMedia(v),
                              ),
                            ),
                            SettingsRow(
                              icon: LucideIcons.download,
                              iconColor: const Color(0xFFC0C0C0),
                              label: 'Auto-Download Articles',
                              trailing: SettingsToggle(
                                value: state.autoDownloadArticles,
                                onChanged: (v) => context.read<AppSettingsCubit>().toggleAutoDownloadArticles(v),
                              ),
                            ),
                            SettingsRow(
                              icon: LucideIcons.lock,
                              iconColor: const Color(0xFFC0C0C0),
                              label: 'Offline Reading',
                              trailing: SettingsToggle(
                                value: state.offlineReading,
                                onChanged: (v) => context.read<AppSettingsCubit>().toggleOfflineReading(v),
                              ),
                            ),
                          ]),
                        ),

                        SizedBox(height: context.scaleHeight(24)),

                        // Cache Storage Card
                        PageEntranceAnimation(
                          delay: const Duration(milliseconds: 170),
                          slideOffset: 10.0,
                          child: CacheCard(
                            size: state.cacheSize,
                            isCleared: state.isCacheCleared,
                            onClear: () => context.read<AppSettingsCubit>().clearCache(),
                          ),
                        ),

                        SizedBox(height: context.scaleHeight(32)),

                        // Version Info Footer
                        PageEntranceAnimation(
                          delay: const Duration(milliseconds: 200),
                          slideOffset: 10.0,
                          child: _buildVersionFooter(context),
                        ),
                      ],
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.scaleWidth(20),
        right: context.scaleWidth(20),
        top: context.scaleHeight(14), // pt-14 (scaled)
        bottom: context.scaleHeight(20), // pb-5 (scaled)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildGlassBackButton(context),
              SizedBox(width: context.scaleWidth(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Settings',
                      style: AppTextStyles.h1(context), // Newsreader 700 28px
                    ),
                    SizedBox(height: context.scaleHeight(4)),
                    Text(
                      'Customise your experience',
                      style: AppTextStyles.settingsSubtitle(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassBackButton(BuildContext context) {
    return PressScaleAnimation(
      onTap: () => context.pop(),
      child: Container(
        width: context.scaleWidth(40), // w-10
        height: context.scaleWidth(40), // h-10
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          shape: BoxShape.circle, // Rounded stadium (50px) -> Circle for w=h
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Icon(
          LucideIcons.arrowLeft,
          size: context.scaleWidth(18),
          color: AppColors.primaryAccent, // Silver icon
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.scaleWidth(4),
        bottom: context.scaleHeight(12),
      ),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.sectionLabel(context).copyWith(
          color: AppColors.foreground.withValues(alpha: 0.5), // Silver /50
          letterSpacing: context.scaleWidth(2.0),
        ),
      ),
    );
  }

  Widget _buildGroupCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.settingsGroup, // 28px token
        border: Border.all(
          color: AppColors.silverBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          return Column(
            children: [
              children[index],
              if (index < children.length - 1)
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                  color: AppColors.silverBorder,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildVersionFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.scaleWidth(20)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.silverBorder,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rasseny Intelligence',
                  style: AppTextStyles.brandLabel(context),
                ),
                Text(
                  'Version 2.0.4 (Build 124)',
                  style: AppTextStyles.caption(context).copyWith(
                    color: AppColors.silverSecondaryLabel,
                  ),
                ),
              ],
            ),
          ),
          PressScaleAnimation(
             onTap: () {},
             child: Container(
               padding: EdgeInsets.symmetric(
                 horizontal: context.scaleWidth(16),
                 vertical: context.scaleHeight(8),
               ),
               decoration: BoxDecoration(
                 color: AppColors.foreground.withValues(alpha: 0.05),
                 borderRadius: BorderRadius.circular(50), // pill
                 border: Border.all(color: AppColors.foreground.withValues(alpha: 0.1)),
               ),
               child: Text(
                 'Check Updates',
                 style: AppTextStyles.buttonLabel(context).copyWith(
                   color: AppColors.foreground,
                   fontSize: context.scaleFontSize(11),
                   fontWeight: FontWeight.w600,
                 ),
               ),
             ),
          ),
        ],
      ),
    );
  }
}


