import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/glass_surface.dart';
import '../../../../core/utils/responsive_util.dart';

/// Header for Login/SignUp with a logo in a glass circle, title, and subtitle.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final double circleSize;
  final IconData? icon;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.circleSize = 80,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Container(
            width: context.scaleWidth(circleSize),
            height: context.scaleWidth(circleSize),
            decoration: GlassSurface.decoration(
              intensity: GlassIntensity.subtle,
              borderRadius: BorderRadius.circular(50),
              borderWidth: 1.185,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: AppColors.foreground,
              size: context.scaleWidth(circleSize * 0.5),
            ),
          ),
          SizedBox(height: context.scaleHeight(24)),
        ],
        Text(
          title,
          style: AppTextStyles.h1(
            context,
          ).copyWith(fontSize: context.scaleFontSize(24), height: 1.33),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: context.scaleHeight(8)),
        Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.scaleFontSize(12),
            height: 1.33,
            color: AppColors.silverSecondaryLabel,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
