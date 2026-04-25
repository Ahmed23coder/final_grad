import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/utils/app_animations.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';

/// Shared header for all 6 subscription screens.
///
/// Spec: top = safe area top + 8, bottom 20, px 20.
/// Back button: 40×40, rounded 50, fill white@6%, stroke white@10%, ArrowLeft 18px Silver.
/// Title: Newsreader 20px Bold white.
/// Subtitle: Inter 10px Silver@40%, 2px below title.
class StandardSubscriptionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const StandardSubscriptionHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.scaleWidth(20),
        right: context.scaleWidth(20),
        top: MediaQuery.of(context).padding.top + context.scaleHeight(8),
        bottom: context.scaleHeight(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PressScaleAnimation(
            onTap: () => context.pop(),
            scaleOnPress: 0.95,
            child: Container(
              width: context.scaleWidth(40),
              height: context.scaleWidth(40),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.10),
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                LucideIcons.arrowLeft,
                color: AppColors.silverPlaceholder,
                size: context.scaleWidth(18),
              ),
            ),
          ),
          SizedBox(width: context.scaleWidth(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Newsreader',
                    fontWeight: FontWeight.w700,
                    fontSize: context.scaleFontSize(20),
                    color: Colors.white,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: context.scaleHeight(2)),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.scaleFontSize(10),
                      color: AppColors.silverPlaceholder.withValues(alpha: 0.40),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}


