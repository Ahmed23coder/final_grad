import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/press_scale_animation.dart';
import '../../../../core/utils/responsive_util.dart';

/// Link text at footer (e.g., "Don't have an account? Sign Up").
class AuthFooterLink extends StatelessWidget {
  final String caption;
  final String actionText;
  final VoidCallback onTap;

  const AuthFooterLink({
    super.key,
    required this.caption,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          caption,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.scaleFontSize(14),
            color: AppColors.silverPlaceholder,
          ),
        ),
        SizedBox(width: context.scaleWidth(4)),
        PressScaleAnimation(
          onTap: onTap,
          child: Text(
            actionText,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: context.scaleFontSize(14),
              color: AppColors.primaryAccent,
            ),
          ),
        ),
      ],
    );
  }
}
