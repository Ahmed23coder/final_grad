import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/theme/app_text_styles.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';

class SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String? subLabel;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    this.subLabel,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      highlightColor: AppColors.foreground.withValues(alpha: 0.05),
      splashColor: AppColors.foreground.withValues(alpha: 0.1),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.scaleWidth(20), // px-5
          vertical: context.scaleHeight(16), // py-4
        ),
        child: Row(
          children: [
            // Left: Icon container w-8 h-8, rounded-18
            Container(
              width: context.scaleWidth(32), // w-8
              height: context.scaleWidth(32), // w-8 (square)
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.22), // 22% opacity background
                borderRadius: BorderRadius.circular(10), // rounded-10 (approx rounded-18 scale-ish)
              ),
              child: Icon(
                icon,
                size: context.scaleWidth(16),
                color: iconColor,
              ),
            ),
            SizedBox(width: context.scaleWidth(12)),
            // Center: Labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.settingsLabel(context),
                  ),
                  if (subLabel != null) ...[
                    SizedBox(height: context.scaleHeight(4)),
                    Text(
                      subLabel!,
                      style: AppTextStyles.cardDescription(context).copyWith(
                        color: AppColors.foreground.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Right: Trailing
            if (trailing != null) ...[
              SizedBox(width: context.scaleWidth(12)),
              trailing!,
            ] else if (onTap != null) ...[
              SizedBox(width: context.scaleWidth(12)),
              Icon(
                LucideIcons.chevronRight,
                size: context.scaleWidth(18),
                color: AppColors.silverSecondaryLabel,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
