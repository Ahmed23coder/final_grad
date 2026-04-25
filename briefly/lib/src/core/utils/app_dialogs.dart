import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/glass_surface.dart';
import 'responsive_util.dart';

class AppDialogs {
  static void showError(BuildContext context, {required String message}) {
    showDialog(
      context: context,
      builder: (context) => _AppPopupDialog(
        title: 'Error',
        message: message,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
      ),
    );
  }

  static void showSuccess(BuildContext context, {required String message}) {
    showDialog(
      context: context,
      builder: (context) => _AppPopupDialog(
        title: 'Success',
        message: message,
        icon: Icons.check_circle_outline,
        iconColor: AppColors.success,
      ),
    );
  }
}

class _AppPopupDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;

  const _AppPopupDialog({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: context.scaleWidth(24)),
      child: ClipRRect(
        borderRadius: AppRadius.card,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            padding: EdgeInsets.all(context.scaleWidth(24)),
            decoration: GlassSurface.decoration(
              intensity: GlassIntensity.elevated,
              borderRadius: AppRadius.card,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor, size: context.scaleWidth(48)),
                SizedBox(height: context.scaleHeight(16)),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.scaleFontSize(18),
                    fontWeight: FontWeight.w700,
                    color: AppColors.foreground,
                  ),
                ),
                SizedBox(height: context.scaleHeight(8)),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.scaleFontSize(14),
                    color: AppColors.silverSecondaryLabel,
                  ),
                ),
                SizedBox(height: context.scaleHeight(24)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.silverGlass,
                      foregroundColor: AppColors.foreground,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.button,
                        side: BorderSide(color: AppColors.silverBorder),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: context.scaleHeight(16),
                      ),
                    ),
                    child: Text(
                      'Dismiss',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: context.scaleFontSize(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
