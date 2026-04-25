import 'package:flutter/material.dart';
import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';

class SettingsToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<SettingsToggle> createState() => _SettingsToggleState();
}

class _SettingsToggleState extends State<SettingsToggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _thumbPosition;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    // spring animation stiffness: 500, damping: 30
    _thumbPosition = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Curves.easeInOutBack, // Approx spring feel
      ),
    );

    if (widget.value) {
      _ctrl.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(SettingsToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _ctrl.forward();
      } else {
        _ctrl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedBuilder(
        animation: _thumbPosition,
        builder: (context, child) {
          return Container(
            width: context.scaleWidth(44), // w-11
            height: context.scaleHeight(24), // h-6
            padding: EdgeInsets.symmetric(
              horizontal: context.scaleWidth(4),
              vertical: context.scaleHeight(4),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color.lerp(
                Colors.white.withValues(alpha: 0.12), // OFF: white/12
                AppColors.primaryAccent, // ON: silver background
                _thumbPosition.value,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: _thumbPosition.value * context.scaleWidth(20), // (w44 - p8 - thumb16) = 20
                  child: Container(
                    width: context.scaleWidth(16), // w-4
                    height: context.scaleHeight(16), // h-4
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.background, // Navy thumb
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
