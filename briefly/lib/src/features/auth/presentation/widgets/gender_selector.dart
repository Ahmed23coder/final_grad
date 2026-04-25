import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../core/widgets/press_scale_animation.dart';

/// Gender selection row with two pill buttons (Male / Female).
class GenderSelector extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String> onSelected;

  const GenderSelector({
    super.key,
    this.selectedGender,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "GENDER",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: context.scaleFontSize(10),
            letterSpacing: 2.0, // Matching 0.2em
            color: AppColors.silverSecondaryLabel,
          ),
        ),
        SizedBox(height: context.scaleHeight(12)),
        Row(
          children: [
            Expanded(
              child: _GenderPill(
                label: "Male",
                isSelected: selectedGender == "Male",
                onTap: () => onSelected("Male"),
              ),
            ),
            SizedBox(width: context.scaleWidth(12)),
            Expanded(
              child: _GenderPill(
                label: "Female",
                isSelected: selectedGender == "Female",
                onTap: () => onSelected("Female"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GenderPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      child: Container(
        height: context.scaleHeight(50),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: isSelected
              ? null
              : Border.all(color: AppColors.silverBorder, width: 1.185),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: context.scaleFontSize(14),
            color: isSelected
                ? AppColors.primaryForeground
                : AppColors.foreground,
          ),
        ),
      ),
    );
  }
}
