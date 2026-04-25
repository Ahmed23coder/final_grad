import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/theme/app_text_styles.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';
import 'package:briefly/src/core/utils/app_animations.dart';

class AboutLinkRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const AboutLinkRow({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      scaleOnPress: 0.96,
      child: Container(
        margin: EdgeInsets.only(bottom: context.scaleHeight(12)),
        padding: EdgeInsets.all(context.scaleWidth(14)),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04), // Glass /4
          borderRadius: BorderRadius.circular(18), // rounded-18
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08), // Glass border /8
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              padding: EdgeInsets.all(context.scaleWidth(8)),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: context.scaleWidth(18),
                color: iconColor,
              ),
            ),
            SizedBox(width: context.scaleWidth(16)),
            // Label
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body(context).copyWith(
                  color: AppColors.foreground,
                  fontSize: context.scaleFontSize(14),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Chevron
            Icon(
              LucideIcons.chevronRight,
              size: context.scaleWidth(18),
              color: AppColors.silverSecondaryLabel, // silver placeholder
            ),
          ],
        ),
      ),
    );
  }
}
