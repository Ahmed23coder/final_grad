import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/theme/app_text_styles.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';
import 'package:briefly/src/core/utils/app_animations.dart';

class OptionPicker<T> extends StatelessWidget {
  final List<T> options;
  final T selected;
  final ValueChanged<T> onSelected;
  final String Function(T) labelBuilder;

  const OptionPicker({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.scaleWidth(8),
      runSpacing: context.scaleHeight(8),
      children: options.map((option) {
        final active = option == selected;
        return PressScaleAnimation(
          onTap: () => onSelected(option),
          scaleOnPress: 0.95,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.scaleWidth(14),
              vertical: context.scaleHeight(8),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: active
                  ? AppColors.primaryAccent.withValues(alpha: 0.15) // Silver /15
                  : Colors.white.withValues(alpha: 0.04), // White /4
              border: Border.all(
                color: active
                    ? AppColors.primaryAccent.withValues(alpha: 0.40) // Silver /40
                    : Colors.white.withValues(alpha: 0.10), // White /10
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (active) ...[
                  Icon(
                    LucideIcons.check,
                    size: context.scaleWidth(10),
                    color: AppColors.primaryAccent,
                  ),
                  SizedBox(width: context.scaleWidth(6)),
                ],
                Text(
                  labelBuilder(option),
                  style: AppTextStyles.body(context).copyWith(
                    color: active ? AppColors.foreground : AppColors.silverSecondaryLabel,
                    fontSize: context.scaleFontSize(12),
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
