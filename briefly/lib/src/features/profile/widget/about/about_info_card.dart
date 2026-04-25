import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/theme/app_text_styles.dart';
import 'package:briefly/src/core/theme/app_radius.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';

class AboutInfoCard extends StatelessWidget {
  final String appName;
  final String tagline;
  final String version;
  final String buildNumber;

  const AboutInfoCard({
    super.key,
    required this.appName,
    required this.tagline,
    required this.version,
    required this.buildNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: context.scaleHeight(32),
        horizontal: context.scaleWidth(24),
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.settingsGroup, // 28px token
        border: Border.all(
          color: AppColors.silverBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Glass Circle with App Logo (anchor icon proxy)
          Container(
            width: context.scaleWidth(80),
            height: context.scaleWidth(80),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              LucideIcons.anchor, // Logo surrogate
              size: context.scaleWidth(32),
              color: AppColors.primaryAccent,
            ),
          ),
          SizedBox(height: context.scaleHeight(20)),
          Text(
            appName,
            style: AppTextStyles.h2(context).copyWith(
              fontSize: context.scaleFontSize(20),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: context.scaleHeight(8)),
          Text(
            tagline,
            style: AppTextStyles.tagline(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.scaleHeight(24)),
          // Version Badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.scaleWidth(14),
              vertical: context.scaleHeight(6),
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.2)),
            ),
            child: Text(
              'Version $version (Build $buildNumber)',
              style: AppTextStyles.versionBadge(context),
            ),
          ),
        ],
      ),
    );
  }
}
