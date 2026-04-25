import 'dart:ui';
import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Glass intensity presets matching the design spec.
enum GlassIntensity { subtle, standard, elevated }

/// Frosted-glass surface widget with backdrop blur.
class GlassSurface extends StatelessWidget {
  final Widget child;
  final GlassIntensity intensity;
  final double blurSigma;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double borderWidth;

  const GlassSurface({
    super.key,
    required this.child,
    this.intensity = GlassIntensity.standard,
    this.blurSigma = 12.0,
    this.borderRadius,
    this.padding,
    this.borderWidth = 1.0,
  });

  Color get _backgroundColor => switch (intensity) {
    GlassIntensity.subtle => AppColors.primaryAccent.withValues(alpha: 0.05),
    GlassIntensity.standard => AppColors.primaryAccent.withValues(alpha: 0.08),
    GlassIntensity.elevated => AppColors.primaryAccent.withValues(alpha: 0.10),
  };

  Color get _borderColor => switch (intensity) {
    GlassIntensity.subtle => AppColors.primaryAccent.withValues(alpha: 0.08),
    GlassIntensity.standard => AppColors.primaryAccent.withValues(alpha: 0.10),
    GlassIntensity.elevated => AppColors.primaryAccent.withValues(alpha: 0.20),
  };

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(24);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: radius,
            border: Border.all(color: _borderColor, width: borderWidth),
          ),
          child: child,
        ),
      ),
    );
  }

  /// Non-blur [BoxDecoration] for opaque dark surfaces.
  static BoxDecoration decoration({
    GlassIntensity intensity = GlassIntensity.standard,
    BorderRadius? borderRadius,
    double borderWidth = 1.0,
  }) {
    final (bg, border) = switch (intensity) {
      GlassIntensity.subtle => (
        AppColors.primaryAccent.withValues(alpha: 0.05),
        AppColors.primaryAccent.withValues(alpha: 0.08),
      ),
      GlassIntensity.standard => (
        AppColors.primaryAccent.withValues(alpha: 0.08),
        AppColors.primaryAccent.withValues(alpha: 0.10),
      ),
      GlassIntensity.elevated => (
        AppColors.primaryAccent.withValues(alpha: 0.10),
        AppColors.primaryAccent.withValues(alpha: 0.20),
      ),
    };
    return BoxDecoration(
      color: bg,
      borderRadius: borderRadius ?? BorderRadius.circular(24),
      border: Border.all(color: border, width: borderWidth),
    );
  }
}
