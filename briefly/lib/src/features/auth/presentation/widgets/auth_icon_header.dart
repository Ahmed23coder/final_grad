import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/glass_surface.dart';
import '../../../../core/utils/responsive_util.dart';
import 'auth_back_button.dart';

/// Top section for Forgot Password, OTP, and Reset Password screens.
/// Features a back button top-left, a hero icon in a glass circle, and text.
class AuthIconHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const AuthIconHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final circleSize = context.scaleWidth(80);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Align(alignment: Alignment.centerLeft, child: AuthBackButton()),
        SizedBox(height: context.scaleHeight(20)),
        Container(
          width: circleSize,
          height: circleSize,
          decoration: GlassSurface.decoration(
            intensity: GlassIntensity.subtle,
            borderRadius: BorderRadius.circular(50),
            borderWidth: 1.185,
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: AppColors.foreground,
            size: circleSize * 0.5,
          ),
        ),
        SizedBox(height: context.scaleHeight(24)),
        Text(
          title,
          style: AppTextStyles.h1(
            context,
          ).copyWith(fontSize: context.scaleFontSize(24), height: 1.33),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: context.scaleHeight(12)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(24)),
          child: Text(
            description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.scaleFontSize(14),
              height: 1.5,
              color: AppColors.silverSecondaryLabel,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
