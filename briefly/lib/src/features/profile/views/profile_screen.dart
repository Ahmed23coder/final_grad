import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/theme/app_radius.dart';
import 'package:briefly/src/core/theme/app_text_styles.dart';
import 'package:briefly/src/core/utils/app_animations.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';
import 'package:briefly/src/core/routes/app_router.dart';
import '../cubits/profile_cubit.dart';
import '../cubits/profile_state.dart';
import '../../../core/constants/app_assets.dart';
import 'package:briefly/src/domain/models/user_profile.dart';

/// Clean Profile screen matching the explicit design system rules.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: context.scaleWidth(20),
                right: context.scaleWidth(20),
                top: context.scaleHeight(14), // pt-14 equiv inside SafeArea
                bottom: context.scaleHeight(128),
              ),
              child: PageEntranceAnimation(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1ï¸âƒ£ Header
                    _Header(),
                    SizedBox(height: context.scaleHeight(24)),

                    // 2ï¸âƒ£ Profile Card
                    _ProfileCard(profile: state.profile),
                    SizedBox(height: context.scaleHeight(24)),

                    // 3ï¸âƒ£ Stats Row
                    _StatsRow(profile: state.profile),
                    SizedBox(height: context.scaleHeight(32)),

                    // 4ï¸âƒ£ Preferences Section
                    _SectionTitle(title: 'PREFERENCES'),
                    _PreferencesGroup(state: state),
                    SizedBox(height: context.scaleHeight(32)),

                    // 5ï¸âƒ£ Account Section
                    _SectionTitle(title: 'ACCOUNT'),
                    _AccountGroup(),
                    SizedBox(height: context.scaleHeight(32)),

                    // 6ï¸âƒ£ Log Out Button
                    _LogOutButton(),
                    SizedBox(height: context.scaleHeight(32)),

                    // 7ï¸âƒ£ Version Footer
                    _VersionFooter(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// HEADER
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Profile',
          style: AppTextStyles.h1(context),
        ),
        // Empty placeholder container (future actions)
        SizedBox(width: context.scaleWidth(24)),
      ],
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// PROFILE CARD
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ProfileCard extends StatelessWidget {
  final UserProfile profile;

  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.scaleWidth(24)), // p-6
      decoration: BoxDecoration(
        color: AppColors.foreground.withValues(alpha: 0.05), // bg white/5
        borderRadius: BorderRadius.circular(32), // strict 32px spec
        border: Border.all(
          color: AppColors.foreground.withValues(alpha: 0.08), // border white/8
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: context.scaleWidth(80),
            height: context.scaleWidth(80),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryAccent.withValues(alpha: 0.3),
                width: 2,
              ),
              image: DecorationImage(
                image: profile.avatarUrl.isNotEmpty
                    ? NetworkImage(profile.avatarUrl) as ImageProvider
                    : const AssetImage(AppAssets.placeholderAvatar),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: context.scaleHeight(16)),

          // Name
          Text(
            profile.fullName.isNotEmpty ? profile.fullName : 'No Name Provided',
            style: TextStyle(
              fontFamily: 'Newsreader',
              fontWeight: FontWeight.w700,
              fontSize: context.scaleFontSize(22),
              color: AppColors.foreground,
            ),
          ),
          SizedBox(height: context.scaleHeight(4)),

          // Email
          Text(
            profile.email,
            style: AppTextStyles.caption(context),
          ),
          SizedBox(height: context.scaleHeight(16)),

          // Membership Badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.scaleWidth(16),
              vertical: context.scaleHeight(6),
            ),
            decoration: BoxDecoration(
              color: AppColors.foreground.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppRadius.pillValue),
              border: Border.all(
                color: AppColors.foreground.withValues(alpha: 0.08),
              ),
            ),
            child: Text(
              profile.membership,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: context.scaleFontSize(11),
                color: AppColors.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// STATS ROW
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _StatsRow extends StatelessWidget {
  final UserProfile profile;

  const _StatsRow({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Articles Read',
            value: profile.articlesRead.toString(),
            route: AppRouter.readingHistory,
          ),
        ),
        SizedBox(width: context.scaleWidth(12)),
        Expanded(
          child: _StatCard(
            label: 'Vault Saved',
            value: profile.vaultSaved.toString(),
            route: AppRouter.saved,
          ),
        ),
        SizedBox(width: context.scaleWidth(12)),
        Expanded(
          child: _StatCard(
            label: 'AI Summaries',
            value: profile.aiSummaries.toString(),
            route: null,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? route;

  const _StatCard({
    required this.label,
    required this.value,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: EdgeInsets.symmetric(vertical: context.scaleHeight(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.cardValue), // 24px
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Newsreader',
              fontWeight: FontWeight.w700,
              fontSize: context.scaleFontSize(22),
              color: AppColors.foreground,
            ),
          ),
          SizedBox(height: context.scaleHeight(4)),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: context.scaleFontSize(9),
              color: AppColors.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    if (route == null) return card;

    return PressScaleAnimation(
      onTap: () => context.push(route!),
      scaleOnPress: 0.95,
      child: card,
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// MENU SECTIONS (PREFERENCES & ACCOUNT)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.scaleWidth(8),
        bottom: context.scaleHeight(12),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: AppTextStyles.sectionLabel(context),
        ),
      ),
    );
  }
}

class _PreferencesGroup extends StatelessWidget {
  final ProfileState state;

  const _PreferencesGroup({required this.state});

  @override
  Widget build(BuildContext context) {
    return _MenuCardContainer(
      children: [
        _MenuRow(
          label: 'Dark Mode',
          icon: LucideIcons.moon,
          trailing: _CustomToggle(
            value: state.darkModeEnabled,
            onChanged: (_) => context.read<ProfileCubit>().toggleDarkMode(),
          ),
        ),
        _MenuRow(
          label: 'Notifications',
          icon: LucideIcons.bell,
          trailing: _CustomToggle(
            value: state.notificationsEnabled,
            onChanged: (_) => context.read<ProfileCubit>().toggleNotifications(),
          ),
        ),
        _MenuRow(
          label: 'Language',
          icon: LucideIcons.globe,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.language,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: context.scaleFontSize(13),
                  color: AppColors.mutedForeground,
                ),
              ),
              SizedBox(width: context.scaleWidth(4)),
              Icon(
                LucideIcons.chevronRight,
                size: context.scaleWidth(16),
                color: AppColors.mutedForeground,
              ),
            ],
          ),
          onTap: () => context.push(AppRouter.language),
        ),
      ],
    );
  }
}

class _AccountGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MenuCardContainer(
      children: [
        _MenuRow(
          label: 'Edit Profile',
          icon: LucideIcons.user,
          onTap: () => context.push(AppRouter.editProfile),
        ),
        _MenuRow(
          label: 'Reset Password',
          icon: LucideIcons.keyRound,
          onTap: () => context.push(AppRouter.profileResetPassword),
        ),
        _MenuRow(
          label: 'Privacy & Security',
          icon: LucideIcons.shield,
          onTap: () => context.push(AppRouter.privacySecurity),
        ),
        _MenuRow(
          label: 'App Settings',
          icon: LucideIcons.settings,
          onTap: () => context.push(AppRouter.appSettings),
        ),
        _MenuRow(
          label: 'Help & Support',
          icon: LucideIcons.circleQuestionMark,
          onTap: () => context.push(AppRouter.helpSupport),
        ),
        _MenuRow(
          label: 'Reading History',
          icon: LucideIcons.history,
          onTap: () => context.push(AppRouter.readingHistory),
        ),
        _MenuRow(
          label: 'Subscription',
          icon: LucideIcons.creditCard,
          onTap: () => context.push(AppRouter.subscription),
        ),
        _MenuRow(
          label: 'About',
          icon: LucideIcons.info,
          onTap: () => context.push(AppRouter.about),
        ),
      ],
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// MENU ROW & CONTAINER HELPERS
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _MenuCardContainer extends StatelessWidget {
  final List<Widget> children;

  const _MenuCardContainer({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.settingsGroupValue), // 28px
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final isLast = index == children.length - 1;
          return Column(
            children: [
              entry.value,
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.borderColor,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _MenuRow({
    required this.label,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget row = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleWidth(20),
        vertical: context.scaleHeight(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: context.scaleWidth(18),
            color: AppColors.primaryAccent,
          ),
          SizedBox(width: context.scaleWidth(14)),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: context.scaleFontSize(14),
                color: AppColors.foreground,
              ),
            ),
          ),
          if (trailing != null)
            trailing!
          else
            Icon(
              LucideIcons.chevronRight,
              size: context.scaleWidth(16),
              color: AppColors.mutedForeground,
            ),
        ],
      ),
    );

    if (onTap == null) return row;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.foreground.withValues(alpha: 0.05),
        highlightColor: AppColors.foreground.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(2),
        child: row,
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// CUSTOM CSS-STYLE TOGGLE
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _CustomToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CustomToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: context.scaleWidth(44),
        height: context.scaleHeight(24),
        padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(2)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.pillValue),
          color: value
              ? AppColors.primaryAccent
              : AppColors.foreground.withValues(alpha: 0.1),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: context.scaleWidth(16),
          height: context.scaleWidth(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: value ? const Color(0xFF102A43) : AppColors.foreground,
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// LOG OUT BUTTON
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _LogOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: () {
        // Logic context clear
      },
      scaleOnPress: 0.95,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: context.scaleHeight(16)),
        decoration: BoxDecoration(
          color: AppColors.destructive.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.pillValue),
          border: Border.all(
            color: AppColors.destructive.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.logOut,
              size: context.scaleWidth(18),
              color: AppColors.destructive,
            ),
            SizedBox(width: context.scaleWidth(8)),
            Text(
              'Log Out',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: context.scaleFontSize(14),
                color: AppColors.destructive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// VERSION FOOTER
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _VersionFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Briefly Intelligence v1.0.0',
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: context.scaleFontSize(10),
        color: AppColors.mutedForeground.withValues(alpha: 0.3),
      ),
      textAlign: TextAlign.center,
    );
  }
}


