import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_util.dart';

/// A 3-bar indicator showing password strength (Weak, Medium, Strong).
class PasswordStrengthIndicator extends StatelessWidget {
  final int strength; // 0-3

  const PasswordStrengthIndicator({super.key, required this.strength});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: List.generate(3, (index) => _buildBar(context, index))),
        SizedBox(height: context.scaleHeight(8)),
        Text(
          _getLabel(),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.scaleFontSize(11),
            fontWeight: FontWeight.w600,
            color: _getColor(strength),
          ),
        ),
      ],
    );
  }

  Widget _buildBar(BuildContext context, int index) {
    final bool isActive = index < strength;
    final Color color = _getColor(strength);

    return Expanded(
      child: Container(
        height: context.scaleHeight(6),
        margin: EdgeInsets.only(right: index < 2 ? context.scaleWidth(6) : 0),
        decoration: BoxDecoration(
          color: isActive
              ? color
              : AppColors.silverInactivePill.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Color _getColor(int s) {
    switch (s) {
      case 1:
        return Colors.redAccent;
      case 2:
        return Colors.orangeAccent;
      case 3:
        return Colors.greenAccent;
      default:
        return AppColors.silverPlaceholder;
    }
  }

  String _getLabel() {
    switch (strength) {
      case 1:
        return "Weak password";
      case 2:
        return "Medium strength";
      case 3:
        return "Strong password";
      default:
        return "Password strength";
    }
  }
}
