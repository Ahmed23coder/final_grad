import 'package:flutter/material.dart';
import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/theme/app_text_styles.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';

class AboutFooter extends StatelessWidget {
  const AboutFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: context.scaleHeight(40)),
        Text(
          'Made with ❤️ by Rasseny Team',
          style: AppTextStyles.caption(context).copyWith(
            color: AppColors.silverSecondaryLabel, // silver muted
            fontSize: context.scaleFontSize(11),
            fontWeight: FontWeight.w400,
            letterSpacing: context.scaleWidth(1.0),
          ),
        ),
        SizedBox(height: context.scaleHeight(8)),
        Text(
          '© 2026 Rasseny Inc. All Rights Reserved.',
          style: AppTextStyles.microText(context).copyWith(
            color: AppColors.silverTimestamp,
            fontSize: context.scaleFontSize(9),
          ),
        ),
        SizedBox(height: context.scaleHeight(24)),
      ],
    );
  }
}
