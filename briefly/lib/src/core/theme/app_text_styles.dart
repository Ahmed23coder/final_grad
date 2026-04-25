import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import '../utils/responsive_util.dart';

/// Briefly Design System — Typography
///
/// Headlines use Poppins; body / UI uses Inter.
class AppTextStyles {
  AppTextStyles._();

  // ── Headlines ────────────────────────────────────────────────

  static TextStyle appName(BuildContext context) => GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: context.scaleFontSize(22),
    height: 1.2,
    color: AppColors.foreground,
  );

  static TextStyle h1(BuildContext context) => GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: context.scaleFontSize(28),
    height: 1.2,
    color: AppColors.foreground,
  );

  static TextStyle h2(BuildContext context) => GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: context.scaleFontSize(21),
    height: 1.3,
    color: AppColors.foreground,
  );

  static TextStyle h4CardHeadline(BuildContext context) => GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: context.scaleFontSize(15),
    color: AppColors.foreground,
  );

  // ── Body / UI ────────────────────────────────────────────────

  static TextStyle body(BuildContext context) => GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: context.scaleFontSize(16),
    height: 1.6,
    color: AppColors.bodyText,
  );

  static TextStyle buttonLabel(BuildContext context) => GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: context.scaleFontSize(15),
    color: AppColors.primaryForeground,
  );

  static TextStyle inputText(BuildContext context) => GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: context.scaleFontSize(14),
    color: AppColors.foreground,
  );

  static TextStyle error(BuildContext context) => GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: context.scaleFontSize(12),
    color: AppColors.destructive,
  );

  static TextStyle caption(BuildContext context) => GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: context.scaleFontSize(10.5),
    color: AppColors.silverTimestamp,
  );

  static TextStyle sectionLabel(BuildContext context) => GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: context.scaleFontSize(10),
    letterSpacing: 2.0,
    color: AppColors.silverSecondaryLabel,
  );

  static TextStyle settingsLabel(BuildContext context) => GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: context.scaleFontSize(14.5),
    color: AppColors.foreground,
  );

  static TextStyle cardDescription(BuildContext context) => GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: context.scaleFontSize(12),
    color: AppColors.mutedForeground,
  );

  static TextStyle microBold(BuildContext context) => GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontSize: context.scaleFontSize(10),
    color: AppColors.foreground,
  );

  static TextStyle tagline(BuildContext context) => GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: context.scaleFontSize(13),
    color: AppColors.mutedForeground,
  );

  static TextStyle versionBadge(BuildContext context) => GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: context.scaleFontSize(11),
    color: AppColors.primaryAccent,
  );

  static TextStyle cardLabel(BuildContext context) => GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: context.scaleFontSize(15),
    color: AppColors.foreground,
  );

  static TextStyle h3(BuildContext context) => GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: context.scaleFontSize(18),
    height: 1.3,
    color: AppColors.foreground,
  );

  static TextStyle microText(BuildContext context) => GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: context.scaleFontSize(10),
    color: AppColors.mutedForeground.withValues(alpha: 0.6),
  );
  
  static TextStyle aboutDescription(BuildContext context) => GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: context.scaleFontSize(14),
    height: 1.6,
    color: AppColors.mutedForeground,
  );

  static TextStyle settingsSubtitle(BuildContext context) => GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: context.scaleFontSize(14),
    color: AppColors.mutedForeground,
  );

  static TextStyle brandLabel(BuildContext context) => GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontSize: context.scaleFontSize(15),
    color: AppColors.foreground,
  );
}
