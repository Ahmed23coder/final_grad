import 'dart:ui';

/// Briefly Design System — Color Tokens
///
/// Every colour in the palette is defined here. UI code should NEVER
/// hard-code hex values; always reference [AppColors].
class AppColors {
  AppColors._();

  // ── Core Palette ─────────────────────────────────────────────
  static const Color background = Color(0xFF0A1A2F); // Deep Navy
  static const Color card = Color(0xFF243B53);
  static const Color secondarySurface = Color(0xFF334E68);
  static const Color muted = Color(0xFF486581);

  static const Color primaryAccent = Color(0xFFC0C0C0); // Silver
  static const Color primaryForeground = Color(0xFF0A1A2F);
  static const Color foreground = Color(0xFFFFFFFF);
  static const Color bodyText = Color(0xFFB0C4DE);
  static const Color mutedForeground = Color(0xFFBCCCDC);

  static const Color accentBlue = Color(0xFF2979FF);
  static const Color destructive = Color(0xFFD4183D);
  static const Color ring = Color(0xFFC0C0C0);
  static const Color success = Color(0xFF00C853);

  // ── Computed Border ──────────────────────────────────────────
  static Color get borderColor => primaryAccent.withValues(alpha: 0.20);

  // ── Silver Opacity Helpers ───────────────────────────────────
  static Color get silver80 => primaryAccent.withValues(alpha: 0.80);
  static Color get silver70 => primaryAccent.withValues(alpha: 0.70);
  static Color get silverSecondaryLabel =>
      primaryAccent.withValues(alpha: 0.60);
  static Color get silverPlaceholder => primaryAccent.withValues(alpha: 0.50);
  static Color get silverTimestamp => primaryAccent.withValues(alpha: 0.40);
  static Color get silverDisabled => primaryAccent.withValues(alpha: 0.30);
  static Color get silverBorder => primaryAccent.withValues(alpha: 0.20);
  static Color get silverInactivePill => primaryAccent.withValues(alpha: 0.15);
  static Color get silver10 => primaryAccent.withValues(alpha: 0.10);
  static Color get silverFaint => silver10;
  static Color get silver08 => primaryAccent.withValues(alpha: 0.08);
  static Color get silver06 => primaryAccent.withValues(alpha: 0.06);
  static Color get silver04 => primaryAccent.withValues(alpha: 0.04);
  static Color get silverGlass => primaryAccent.withValues(alpha: 0.05);

  // Legacy aliases
  static const Color error = destructive;
}
