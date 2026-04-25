import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_util.dart';

/// Divider for social auth options with centered text.
class AuthDivider extends StatelessWidget {
  final String text;

  const AuthDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.silverBorder, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(16)),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.scaleFontSize(12),
              color: AppColors.silverPlaceholder,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.silverBorder, thickness: 1)),
      ],
    );
  }
}
