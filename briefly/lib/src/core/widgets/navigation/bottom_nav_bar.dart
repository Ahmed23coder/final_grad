import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';

/// Bottom navigation bar with 6 tabs using LucideIcons and glassmorphism.
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _tabs = <_NavTab>[
    _NavTab(
      activeIcon: LucideIcons.house600,
      inactiveIcon: LucideIcons.house400,
      label: 'Home',
    ),
    _NavTab(
      activeIcon: LucideIcons.search600,
      inactiveIcon: LucideIcons.search400,
      label: 'Search',
    ),
    _NavTab(
      activeIcon: LucideIcons.sparkles600,
      inactiveIcon: LucideIcons.sparkles400,
      label: 'Summarize',
    ),
    _NavTab(
      activeIcon: LucideIcons.shieldCheck600,
      inactiveIcon: LucideIcons.shieldCheck400,
      label: 'Fact Check',
    ),
    _NavTab(
      activeIcon: LucideIcons.bookmark600,
      inactiveIcon: LucideIcons.bookmark400,
      label: 'Vault',
    ),
    _NavTab(
      activeIcon: LucideIcons.user600,
      inactiveIcon: LucideIcons.user400,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final maxWidth = context.scaleWidth(393);
    final barHeight = context.scaleHeight(68); // Adjusted slightly for Lucide sizing

    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            height: barHeight + MediaQuery.paddingOf(context).bottom,
            padding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(context).bottom,
            ),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.95),
              border: Border(top: BorderSide(color: AppColors.silverBorder, width: 0.5)),
            ),
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final active = i == currentIndex;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap(i),
                    child: _TabItem(
                      tab: _tabs[i],
                      active: active,
                      barHeight: barHeight,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTab {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  const _NavTab({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}

class _TabItem extends StatelessWidget {
  final _NavTab tab;
  final bool active;
  final double barHeight;

  const _TabItem({
    required this.tab,
    required this.active,
    required this.barHeight,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = active
        ? AppColors.primaryAccent
        : AppColors.primaryAccent.withValues(alpha: 0.35);

    return SizedBox(
      height: barHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          Icon(
            active ? tab.activeIcon : tab.inactiveIcon,
            color: iconColor,
            size: context.scaleWidth(22),
          ),
          const SizedBox(height: 4),
          Text(
            tab.label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.scaleFontSize(10),
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 6),
          // Active Indicator moved below text
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: context.scaleHeight(3),
            width: active ? context.scaleWidth(42) : 0,
            decoration: BoxDecoration(
              color: active ? AppColors.primaryAccent : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
