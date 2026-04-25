import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/glass_surface.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/press_scale_animation.dart';
import '../../../../core/utils/responsive_util.dart';

/// A 40px glass circle button for back navigation in auth flows.
class AuthBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AuthBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = context.scaleWidth(40);

    return PressScaleAnimation(
      onTap:
          onTap ??
          () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/auth'); // Default to login if can't pop
            }
          },
      child: Container(
        width: size,
        height: size,
        decoration: GlassSurface.decoration(
          intensity: GlassIntensity.subtle,
          borderRadius: AppRadius.button,
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.chevron_left_rounded,
          color: AppColors.primaryAccent, // Silver color
          size: context.scaleWidth(20),
        ),
      ),
    );
  }
}
