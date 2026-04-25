import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/utils/app_animations.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GLOBAL BUTTON TOKENS & HELPERS
// ─────────────────────────────────────────────────────────────────────────────

/// Common button transition duration
const kButtonTransition = Duration(milliseconds: 200);

/// Shared button text style
TextStyle _buttonTextStyle(BuildContext context, {required double fontSize, required FontWeight fontWeight, required Color color}) {
  return TextStyle(
    fontFamily: 'Inter',
    fontSize: context.scaleFontSize(fontSize),
    fontWeight: fontWeight,
    color: color,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. PRIMARY CTA (Silver Full-Width)
// ─────────────────────────────────────────────────────────────────────────────
class SubPrimaryButton extends StatelessWidget {
  final String label;
  final IconData? iconLeft;
  final IconData? iconRight;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool enabled;

  const SubPrimaryButton({
    super.key,
    required this.label,
    this.iconLeft,
    this.iconRight,
    this.onTap,
    this.isLoading = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActuallyEnabled = enabled && !isLoading && onTap != null;

    return PressScaleAnimation(
      onTap: isActuallyEnabled ? onTap : null,
      scaleOnPress: 0.95,
      child: AnimatedContainer(
        duration: kButtonTransition,
        width: double.infinity,
        height: context.scaleHeight(56),
        decoration: BoxDecoration(
          color: isActuallyEnabled
              ? AppColors.primaryAccent
              : AppColors.silverDisabled,
          borderRadius: BorderRadius.circular(50),
          boxShadow: isActuallyEnabled
              ? [
                  BoxShadow(
                    color: AppColors.primaryAccent.withValues(alpha: 0.20),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(24)),
        alignment: Alignment.center,
        child: isLoading
            ? const PulsingDots()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (iconLeft != null) ...[
                    Icon(
                      iconLeft,
                      size: context.scaleWidth(18),
                      color: isActuallyEnabled
                          ? AppColors.primaryForeground
                          : AppColors.primaryForeground.withValues(alpha: 0.30),
                    ),
                    SizedBox(width: context.scaleWidth(10)),
                  ],
                  Text(
                    label,
                    style: _buttonTextStyle(
                      context,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isActuallyEnabled
                          ? AppColors.primaryForeground
                          : AppColors.primaryForeground.withValues(alpha: 0.30),
                    ),
                  ),
                  if (iconRight != null) ...[
                    SizedBox(width: context.scaleWidth(10)),
                    Icon(
                      iconRight,
                      size: context.scaleWidth(18),
                      color: isActuallyEnabled
                          ? AppColors.primaryForeground
                          : AppColors.primaryForeground.withValues(alpha: 0.30),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. SECONDARY TEXT BUTTON (Ghost)
// ─────────────────────────────────────────────────────────────────────────────
class SubSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const SubSecondaryButton({
    super.key,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      scaleOnPress: 0.95,
      child: Container(
        width: double.infinity,
        height: context.scaleHeight(44),
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Text(
          label,
          style: _buttonTextStyle(
            context,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.silverPlaceholder,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. SECONDARY OUTLINED BUTTON
// ─────────────────────────────────────────────────────────────────────────────
class SubSecondaryOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const SubSecondaryOutlinedButton({
    super.key,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      scaleOnPress: 0.95,
      child: Container(
        width: double.infinity,
        height: context.scaleHeight(52),
        decoration: BoxDecoration(
          color: AppColors.silver06,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.silverBorder),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: _buttonTextStyle(
            context,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.silverSecondaryLabel,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. DESTRUCTIVE BUTTON (Red)
// ─────────────────────────────────────────────────────────────────────────────
class SubDestructiveButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool enabled;

  const SubDestructiveButton({
    super.key,
    required this.label,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActuallyEnabled = enabled && onTap != null;
    return PressScaleAnimation(
      onTap: isActuallyEnabled ? onTap : null,
      scaleOnPress: 0.95,
      child: AnimatedContainer(
        duration: kButtonTransition,
        width: double.infinity,
        height: context.scaleHeight(52),
        decoration: BoxDecoration(
          color: isActuallyEnabled
              ? AppColors.destructive.withValues(alpha: 0.15)
              : AppColors.silver04,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isActuallyEnabled
                ? AppColors.destructive.withValues(alpha: 0.30)
                : AppColors.silver08,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: _buttonTextStyle(
            context,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isActuallyEnabled
                ? const Color(0xFFf87171) // Lighter red for visibility on navy
                : AppColors.silverDisabled,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. PLAN SELECTION CARD (Tappable)
// ─────────────────────────────────────────────────────────────────────────────
class PlanSelectionCard extends StatelessWidget {
  final String name;
  final String price;
  final String interval;
  final Color planColor;
  final IconData icon;
  final List<String> features;
  final bool isSelected;
  final bool isPopular;
  final bool isBestValue;
  final String? discountText;
  final VoidCallback onTap;
  final bool isUpgradeVariant;

  const PlanSelectionCard({
    super.key,
    required this.name,
    required this.price,
    required this.interval,
    required this.planColor,
    required this.icon,
    required this.features,
    required this.isSelected,
    required this.onTap,
    this.isPopular = false,
    this.isBestValue = false,
    this.discountText,
    this.isUpgradeVariant = false,
  });

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      scaleOnPress: 0.98,
      child: AnimatedContainer(
        duration: kButtonTransition,
        width: double.infinity,
        padding: EdgeInsets.all(context.scaleWidth(20)),
        decoration: BoxDecoration(
          color: isSelected
              ? (isUpgradeVariant 
                  ? null // Handled by gradient
                  : AppColors.primaryAccent.withValues(alpha: 0.10))
              : AppColors.silver04,
          gradient: (isSelected && isUpgradeVariant)
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    planColor.withValues(alpha: 0.12),
                    planColor.withValues(alpha: 0.04),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected
                ? (isUpgradeVariant ? planColor.withValues(alpha: 0.40) : AppColors.primaryAccent.withValues(alpha: 0.40))
                : AppColors.silver08,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icon Box
                    Container(
                      width: context.scaleWidth(isUpgradeVariant ? 48 : 40),
                      height: context.scaleWidth(isUpgradeVariant ? 48 : 40),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isUpgradeVariant
                                ? planColor.withValues(alpha: 0.15)
                                : AppColors.primaryAccent.withValues(alpha: 0.20))
                            : AppColors.silver06,
                        borderRadius: BorderRadius.circular(isUpgradeVariant ? 18 : 16),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        icon,
                        size: context.scaleWidth(isUpgradeVariant ? 22 : 18),
                        color: isUpgradeVariant
                            ? planColor
                            : (isSelected ? AppColors.primaryAccent : AppColors.silverPlaceholder),
                      ),
                    ),
                    SizedBox(width: context.scaleWidth(14)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                name,
                                style: _buttonTextStyle(context, fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                              if (isPopular && !isUpgradeVariant) ...[
                                SizedBox(width: context.scaleWidth(8)),
                                const BadgePill(type: BadgeType.popular),
                              ],
                            ],
                          ),
                          SizedBox(height: context.scaleHeight(4)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                price,
                                style: TextStyle(
                                  fontFamily: 'Newsreader',
                                  fontSize: context.scaleFontSize(26),
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: context.scaleWidth(6)),
                              Text(
                                interval,
                                style: _buttonTextStyle(context, fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.silverPlaceholder),
                              ),
                              if (discountText != null) ...[
                                SizedBox(width: context.scaleWidth(10)),
                                Text(
                                  discountText!,
                                  style: _buttonTextStyle(context, fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF4ade80)),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    SubRadio(isSelected: isSelected, isLarge: isUpgradeVariant),
                  ],
                ),
                SizedBox(height: context.scaleHeight(16)),
                Padding(
                  padding: EdgeInsets.only(left: context.scaleWidth(isUpgradeVariant ? 62 : 54)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: features.map((f) => Padding(
                      padding: EdgeInsets.only(bottom: context.scaleHeight(10)),
                      child: Row(
                        children: [
                          Icon(LucideIcons.check, size: context.scaleWidth(14), color: isSelected ? AppColors.primaryAccent : AppColors.silverDisabled),
                          SizedBox(width: context.scaleWidth(10)),
                          Expanded(
                            child: Text(
                              f,
                              style: _buttonTextStyle(context, fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.silverSecondaryLabel),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
              ],
            ),
            if (isUpgradeVariant && isBestValue)
              const Positioned(top: -20, right: 0, child: BadgePill(type: BadgeType.bestValue)),
            if (isUpgradeVariant && isPopular && !isBestValue)
              const Positioned(top: -20, right: 0, child: BadgePill(type: BadgeType.mostPopularRibbon)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 7. BADGE PILLS
// ─────────────────────────────────────────────────────────────────────────────
enum BadgeType { popular, active, bestValue, mostPopularRibbon, discount }

class BadgePill extends StatelessWidget {
  final BadgeType type;
  final String? label;
  const BadgePill({super.key, required this.type, this.label});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case BadgeType.popular:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(10), vertical: context.scaleHeight(4)),
          decoration: BoxDecoration(
            color: AppColors.primaryAccent,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryAccent.withValues(alpha: 0.20),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text('POPULAR', style: _badgeStyle(context, AppColors.primaryForeground)),
        );
      case BadgeType.active:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(10), vertical: context.scaleHeight(4)),
          decoration: BoxDecoration(
            color: const Color(0xFF4ade80).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: const Color(0xFF4ade80).withValues(alpha: 0.30)),
          ),
          child: Text('ACTIVE', style: _badgeStyle(context, const Color(0xFF4ade80))),
        );
      case BadgeType.bestValue:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(14), vertical: context.scaleHeight(6)),
          decoration: BoxDecoration(
            color: const Color(0xFF22c55e),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF22c55e).withValues(alpha: 0.30),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text('BEST VALUE', style: _badgeStyle(context, Colors.white)),
        );
      case BadgeType.mostPopularRibbon:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(14), vertical: context.scaleHeight(6)),
          decoration: BoxDecoration(
            color: AppColors.primaryAccent,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryAccent.withValues(alpha: 0.30),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text('MOST POPULAR', style: _badgeStyle(context, AppColors.primaryForeground)),
        );
      case BadgeType.discount:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(10), vertical: context.scaleHeight(4)),
          decoration: BoxDecoration(
            color: const Color(0xFFa78bfa).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: const Color(0xFFa78bfa).withValues(alpha: 0.30)),
          ),
          child: Text(label ?? 'DISCOUNT', style: _badgeStyle(context, const Color(0xFFa78bfa))),
        );
    }
  }

  TextStyle _badgeStyle(BuildContext context, Color color) {
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: context.scaleFontSize(9),
      fontWeight: FontWeight.w700,
      color: color,
      letterSpacing: 1.0,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 8. QUICK ACTION ROW BUTTON
// ─────────────────────────────────────────────────────────────────────────────
class QuickActionRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const QuickActionRow({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      scaleOnPress: 0.98,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(20), vertical: context.scaleHeight(18)),
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withValues(alpha: 0.20)),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 18, color: color),
            ),
            SizedBox(width: context.scaleWidth(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: _buttonTextStyle(context, fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
                  SizedBox(height: context.scaleHeight(4)),
                  Text(subtitle, style: _buttonTextStyle(context, fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.silverPlaceholder)),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, size: 16, color: AppColors.silverDisabled),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 9. CANCEL DANGER BUTTON
// ─────────────────────────────────────────────────────────────────────────────
class CancelDangerRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const CancelDangerRow({
    super.key,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      scaleOnPress: 0.98,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(20), vertical: context.scaleHeight(18)),
        decoration: BoxDecoration(
          color: AppColors.destructive.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.destructive.withValues(alpha: 0.20)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.destructive.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.destructive.withValues(alpha: 0.25)),
              ),
              alignment: Alignment.center,
              child: const Icon(LucideIcons.circleX, size: 18, color: Color(0xFFf87171)),
            ),
            SizedBox(width: context.scaleWidth(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: _buttonTextStyle(context, fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFFf87171))),
                  SizedBox(height: context.scaleHeight(4)),
                  Text(subtitle, style: _buttonTextStyle(context, fontSize: 11, fontWeight: FontWeight.w400, color: const Color(0xFFf87171).withValues(alpha: 0.50))),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFFf87171)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 10. CANCEL REASON PILL
// ─────────────────────────────────────────────────────────────────────────────
class CancelReasonPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CancelReasonPill({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      scaleOnPress: 0.95,
      child: AnimatedContainer(
        duration: kButtonTransition,
        width: double.infinity,
        margin: EdgeInsets.only(bottom: context.scaleHeight(12)),
        padding: EdgeInsets.symmetric(vertical: context.scaleHeight(14), horizontal: context.scaleWidth(20)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.destructive.withValues(alpha: 0.15) : AppColors.silver04,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? AppColors.destructive.withValues(alpha: 0.40) : AppColors.silver08,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: _buttonTextStyle(
                  context,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? const Color(0xFFfca5a5) : AppColors.silverSecondaryLabel,
                ),
              ),
            ),
            if (isSelected)
              const Icon(LucideIcons.circleCheck, size: 16, color: Color(0xFFfca5a5)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 11. PAYMENT CARD TILE (Selectable)
// ─────────────────────────────────────────────────────────────────────────────
class PaymentCardTile extends StatelessWidget {
  final String brand;
  final String last4;
  final String holderName;
  final String expiry;
  final bool isDefault;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final Color brandColor;

  const PaymentCardTile({
    super.key,
    required this.brand,
    required this.last4,
    required this.holderName,
    required this.expiry,
    required this.onTap,
    required this.onDelete,
    required this.brandColor,
    this.isDefault = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      scaleOnPress: 0.98,
      child: AnimatedContainer(
        duration: kButtonTransition,
        width: double.infinity,
        margin: EdgeInsets.only(bottom: context.scaleHeight(16)),
        padding: EdgeInsets.all(context.scaleWidth(18)),
        decoration: BoxDecoration(
          color: isSelected ? null : AppColors.silver04,
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [brandColor.withValues(alpha: 0.12), brandColor.withValues(alpha: 0.04)],
                )
              : null,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? brandColor.withValues(alpha: 0.40) : AppColors.silver08,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 34,
              decoration: BoxDecoration(
                color: brandColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: brandColor.withValues(alpha: 0.25)),
              ),
              alignment: Alignment.center,
              child: Text(brand, style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w800, color: brandColor, letterSpacing: 0.5)),
            ),
            SizedBox(width: context.scaleWidth(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '•••• •••• •••• $last4',
                          style: _buttonTextStyle(context, fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (isDefault) ...[
                        SizedBox(width: context.scaleWidth(10)),
                        const BadgePill(type: BadgeType.active),
                      ],
                    ],
                  ),
                  SizedBox(height: context.scaleHeight(4)),
                  Text(
                    '$holderName · Exp $expiry',
                    style: _buttonTextStyle(context, fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.silverPlaceholder),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            PressScaleAnimation(
              onTap: onDelete,
              scaleOnPress: 0.90,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.destructive.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AppColors.destructive.withValues(alpha: 0.15)),
                ),
                alignment: Alignment.center,
                child: const Icon(LucideIcons.trash2, size: 14, color: Color(0xFFf87171)),
              ),
            ),
            SizedBox(width: context.scaleWidth(12)),
            SubRadio(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 12. ADD CARD BUTTON (Dashed)
// ─────────────────────────────────────────────────────────────────────────────
class AddCardDashedButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddCardDashedButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      scaleOnPress: 0.98,
      child: Container(
        width: double.infinity,
        height: context.scaleHeight(60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.silverBorder, 
            width: 1.5, 
            style: BorderStyle.solid // Simplified dashed look
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.primaryAccent.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.plus, size: 14, color: AppColors.primaryAccent),
            ),
            SizedBox(width: context.scaleWidth(12)),
            Text('Add New Payment Method', style: _buttonTextStyle(context, fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.silverSecondaryLabel)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 13. COMPARISON TOGGLE BUTTON
// ─────────────────────────────────────────────────────────────────────────────
class ComparisonToggleButton extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const ComparisonToggleButton({
    super.key,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      scaleOnPress: 0.95,
      child: Container(
        width: double.infinity,
        height: context.scaleHeight(52),
        decoration: BoxDecoration(
          color: AppColors.silver06,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.silver08),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.listFilter, size: 14, color: AppColors.silverSecondaryLabel),
            SizedBox(width: context.scaleWidth(10)),
            Text(
              isExpanded ? 'Hide Feature Comparison' : 'View Feature Comparison',
              style: _buttonTextStyle(context, fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.silverSecondaryLabel),
            ),
            SizedBox(width: context.scaleWidth(8)),
            Icon(
              isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
              size: 14,
              color: AppColors.silverPlaceholder,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 14. TERMS CHECKBOX BUTTON
// ─────────────────────────────────────────────────────────────────────────────
class TermsCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const TermsCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: () => onChanged(!isChecked),
      scaleOnPress: 0.98,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: kButtonTransition,
            width: 22,
            height: 22,
            margin: EdgeInsets.only(top: context.scaleHeight(2)),
            decoration: BoxDecoration(
              color: isChecked ? AppColors.primaryAccent : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isChecked ? AppColors.primaryAccent : AppColors.silverBorder, 
                width: 2
              ),
            ),
            alignment: Alignment.center,
            child: isChecked ? const Icon(LucideIcons.check, size: 14, color: AppColors.primaryForeground) : null,
          ),
          SizedBox(width: context.scaleWidth(14)),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(text: 'Terms of Service', style: TextStyle(color: AppColors.primaryAccent, fontWeight: FontWeight.w600)),
                  const TextSpan(text: ' and acknowledge the '),
                  TextSpan(text: 'Privacy Policy', style: TextStyle(color: AppColors.primaryAccent, fontWeight: FontWeight.w600)),
                ],
              ),
              style: _buttonTextStyle(context, fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.silverPlaceholder).copyWith(height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 15. CLOSE BUTTON (Bottom Sheet Header)
// ─────────────────────────────────────────────────────────────────────────────
class SubBottomSheetCloseButton extends StatelessWidget {
  final VoidCallback onTap;
  const SubBottomSheetCloseButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      scaleOnPress: 0.92,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.silver06,
          border: Border.all(color: AppColors.silver08),
        ),
        alignment: Alignment.center,
        child: const Icon(LucideIcons.x, size: 16, color: AppColors.primaryAccent),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 16. ADD CARD FORM SUBMIT BUTTON
// ─────────────────────────────────────────────────────────────────────────────
class FormSubmitButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final bool enabled;
  final VoidCallback? onTap;

  const FormSubmitButton({
    super.key,
    required this.label,
    this.isLoading = false,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActuallyEnabled = enabled && !isLoading && onTap != null;
    return PressScaleAnimation(
      onTap: isActuallyEnabled ? onTap : null,
      scaleOnPress: 0.95,
      child: AnimatedContainer(
        duration: kButtonTransition,
        width: double.infinity,
        height: context.scaleHeight(56),
        decoration: BoxDecoration(
          color: isActuallyEnabled ? AppColors.primaryAccent : AppColors.silverDisabled,
          borderRadius: BorderRadius.circular(50),
          boxShadow: isActuallyEnabled
              ? [
                  BoxShadow(
                    color: AppColors.primaryAccent.withValues(alpha: 0.20),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SpinningIcon(icon: LucideIcons.loader, size: 18, color: AppColors.primaryForeground, period: const Duration(seconds: 1))
            else if (isActuallyEnabled)
              Icon(LucideIcons.check, size: 18, color: AppColors.primaryForeground),
            if (isLoading || isActuallyEnabled) SizedBox(width: context.scaleWidth(12)),
            Text(
              isLoading ? 'Processing...' : label,
              style: _buttonTextStyle(
                context,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isActuallyEnabled ? AppColors.primaryForeground : AppColors.primaryForeground.withValues(alpha: 0.30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 17. PURCHASE SELECTION CARD (Restore Screen)
// ─────────────────────────────────────────────────────────────────────────────
class PurchaseSelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PurchaseSelectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      scaleOnPress: 0.98,
      child: AnimatedContainer(
        duration: kButtonTransition,
        width: double.infinity,
        margin: EdgeInsets.only(bottom: context.scaleHeight(12)),
        padding: EdgeInsets.all(context.scaleWidth(18)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryAccent.withValues(alpha: 0.10) : AppColors.silver04,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primaryAccent.withValues(alpha: 0.40) : AppColors.silver08,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryAccent.withValues(alpha: 0.15) : AppColors.silver06,
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 20, color: isSelected ? AppColors.primaryAccent : AppColors.silverPlaceholder),
            ),
            SizedBox(width: context.scaleWidth(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: _buttonTextStyle(context, fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
                  SizedBox(height: context.scaleHeight(4)),
                  Text(subtitle, style: _buttonTextStyle(context, fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.silverPlaceholder)),
                ],
              ),
            ),
            SubRadio(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 18. BILLING INFO ROW (Tappable)
// ─────────────────────────────────────────────────────────────────────────────
class BillingInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool showDivider;

  const BillingInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      scaleOnPress: 0.98,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(20), vertical: context.scaleHeight(18)),
            child: Row(
              children: [
                Expanded(child: Text(label, style: _buttonTextStyle(context, fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white))),
                SizedBox(width: context.scaleWidth(12)),
                Flexible(
                  child: Text(
                    value,
                    style: _buttonTextStyle(context, fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primaryAccent),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: context.scaleWidth(10)),
                Icon(LucideIcons.chevronRight, size: 16, color: AppColors.silverDisabled),
              ],
            ),
          ),
          if (showDivider)
            Container(height: 1, color: AppColors.silver08, margin: EdgeInsets.symmetric(horizontal: context.scaleWidth(20))),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 19. FORM INPUT FIELDS (Add Card Sheet)
// ─────────────────────────────────────────────────────────────────────────────
class FormInputField extends StatelessWidget {
  final String label;
  final String placeholder;
  final bool hasIcon;
  final IconData? icon;
  final TextEditingController? controller;
  final bool isHalfWidth;
  final List<TextInputFormatter>? inputFormatters;

  const FormInputField({
    super.key,
    required this.label,
    required this.placeholder,
    this.hasIcon = false,
    this.icon,
    this.controller,
    this.isHalfWidth = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: context.scaleWidth(8), bottom: context.scaleHeight(10)),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.scaleFontSize(10),
              color: AppColors.silverPlaceholder,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          height: context.scaleHeight(56),
          decoration: BoxDecoration(
            color: AppColors.silver04,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.silverBorder),
          ),
          child: TextField(
            controller: controller,
            style: _buttonTextStyle(context, fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
            cursorColor: AppColors.primaryAccent,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: AppColors.silverDisabled),
              prefixIcon: hasIcon ? Icon(icon, size: 16, color: AppColors.silverPlaceholder) : null,
              contentPadding: EdgeInsets.symmetric(horizontal: context.scaleWidth(20), vertical: context.scaleHeight(16)),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16), 
                borderSide: const BorderSide(color: AppColors.primaryAccent, width: 1.5)
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 20. SUB HERO BANNER
// ─────────────────────────────────────────────────────────────────────────────
class SubHeroBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color themeColor;

  const SubHeroBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return PageEntranceAnimation(
      delay: const Duration(milliseconds: 100),
      child: Container(
        padding: EdgeInsets.all(context.scaleWidth(24)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeColor.withValues(alpha: 0.15),
              AppColors.background,
            ],
          ),
          border: Border.all(color: themeColor.withValues(alpha: 0.20), width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, 
                  color: themeColor.withValues(alpha: 0.05)
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: themeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: themeColor.withValues(alpha: 0.25), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withValues(alpha: 0.10),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 28, color: themeColor),
                ),
                SizedBox(width: context.scaleWidth(20)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Newsreader', 
                          fontSize: context.scaleFontSize(18), 
                          fontWeight: FontWeight.w700, 
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: context.scaleHeight(6)),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: 'Inter', 
                          fontSize: context.scaleFontSize(12), 
                          color: AppColors.silverSecondaryLabel, 
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 21. RESTORE PURCHASE CARD (Restore Screen)
// ─────────────────────────────────────────────────────────────────────────────
class RestorePurchaseCard extends StatelessWidget {
  final String name;
  final String price;
  final String date;
  final String platform;
  final String txnId;
  final bool isSelected;
  final VoidCallback onTap;

  const RestorePurchaseCard({
    super.key,
    required this.name,
    required this.price,
    required this.date,
    required this.platform,
    required this.txnId,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      scaleOnPress: 0.98,
      child: AnimatedContainer(
        duration: kButtonTransition,
        margin: EdgeInsets.only(bottom: context.scaleHeight(16)),
        padding: EdgeInsets.all(context.scaleWidth(18)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryAccent.withValues(alpha: 0.10) : AppColors.silver04,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primaryAccent.withValues(alpha: 0.40) : AppColors.silver08,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (isSelected ? AppColors.primaryAccent : AppColors.silverPlaceholder).withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                platform.toLowerCase().contains('apple') ? LucideIcons.apple : LucideIcons.play,
                size: 20,
                color: isSelected ? AppColors.primaryAccent : AppColors.silverPlaceholder,
              ),
            ),
            SizedBox(width: context.scaleWidth(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: _buttonTextStyle(context, fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                  SizedBox(height: context.scaleHeight(4)),
                  Text('$price · $date', style: _buttonTextStyle(context, fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.silverPlaceholder)),
                ],
              ),
            ),
            SubRadio(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 22. COMPARISON TABLE
// ─────────────────────────────────────────────────────────────────────────────
class ComparisonTable extends StatelessWidget {
  final List<ComparisonRowData> rows;
  const ComparisonTable({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return SubCard(
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final i = entry.key;
          final r = entry.value;
          final isHeader = r.isHeader;
          final showDivider = i < rows.length - 1;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(20), vertical: context.scaleHeight(14)),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          if (r.icon != null) ...[
                            Icon(r.icon, size: 12, color: AppColors.primaryAccent.withValues(alpha: 0.40)),
                            SizedBox(width: context.scaleWidth(10)),
                          ],
                          Expanded(
                            child: Text(
                              isHeader ? r.feature.toUpperCase() : r.feature,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: context.scaleFontSize(isHeader ? 10 : 13),
                                fontWeight: isHeader ? FontWeight.w700 : FontWeight.w400,
                                letterSpacing: isHeader ? 1.5 : null,
                                color: isHeader ? AppColors.silverSecondaryLabel : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...r.values.map((v) => Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          v.text,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.scaleFontSize(11),
                            fontWeight: v.highlight ? FontWeight.w600 : FontWeight.w400,
                            color: v.highlight ? AppColors.primaryAccent : AppColors.silverPlaceholder,
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              if (showDivider) 
                Container(height: 1, color: AppColors.silver08, margin: EdgeInsets.symmetric(horizontal: context.scaleWidth(16))),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class ComparisonRowData {
  final String feature;
  final IconData? icon;
  final List<ComparisonValue> values;
  final bool isHeader;

  ComparisonRowData({
    required this.feature,
    this.icon,
    required this.values,
    this.isHeader = false,
  });
}

class ComparisonValue {
  final String text;
  final bool highlight;
  ComparisonValue(this.text, {this.highlight = false});
}

// ─────────────────────────────────────────────────────────────────────────────
// 22. TESTIMONIAL SCROLLER
// ─────────────────────────────────────────────────────────────────────────────
class TestimonialScroller extends StatelessWidget {
  final List<Map<String, dynamic>> testimonials;
  const TestimonialScroller({super.key, required this.testimonials});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SubSectionLabel('WHAT USERS SAY'),
        SizedBox(height: context.scaleHeight(16)),
        SizedBox(
          height: context.scaleHeight(160),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: context.scaleWidth(20), right: context.scaleWidth(20)),
            itemCount: testimonials.length,
            separatorBuilder: (_, __) => SizedBox(width: context.scaleWidth(14)),
            itemBuilder: (context, index) {
              final t = testimonials[index];
              final starCount = t['stars'] as int;
              return Container(
                width: 240,
                padding: EdgeInsets.all(context.scaleWidth(20)),
                decoration: BoxDecoration(
                  color: AppColors.silver04,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.silver08),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (s) {
                        final isFilled = s < starCount;
                        return Padding(
                          padding: const EdgeInsets.only(right: 3),
                          child: Icon(LucideIcons.star, size: 12, color: isFilled ? const Color(0xFFfbbf24) : AppColors.silverDisabled),
                        );
                      }),
                    ),
                    SizedBox(height: context.scaleHeight(14)),
                    Expanded(
                      child: Text(
                        '"${t['quote']}"',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.scaleFontSize(12),
                          color: AppColors.silverSecondaryLabel,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    SizedBox(height: context.scaleHeight(14)),
                    Text(
                      '— ${t['name']}',
                      style: TextStyle(
                        fontFamily: 'Inter', 
                        fontSize: context.scaleFontSize(11), 
                        fontWeight: FontWeight.w600, 
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEGACY / SHARED UTILITIES
// ─────────────────────────────────────────────────────────────────────────────

class SubSectionLabel extends StatelessWidget {
  final String text;
  const SubSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: context.scaleWidth(8)),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: context.scaleFontSize(10),
          color: AppColors.silverPlaceholder,
          fontWeight: FontWeight.w600,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}

class SubCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;

  const SubCard({
    super.key,
    required this.child,
    this.padding,
    this.radius = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.silver04,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.silver08),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SubRadio extends StatelessWidget {
  final bool isSelected;
  final bool isLarge;
  const SubRadio({super.key, required this.isSelected, this.isLarge = false});

  @override
  Widget build(BuildContext context) {
    final size = isLarge ? 26.0 : 22.0;
    return AnimatedContainer(
      duration: kButtonTransition,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primaryAccent : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.primaryAccent : AppColors.silverBorder,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Icon(
                LucideIcons.check,
                size: isLarge ? 14 : 12,
                color: AppColors.primaryForeground,
              ),
            )
          : null,
    );
  }
}

class PulsingDots extends StatefulWidget {
  const PulsingDots({super.key});

  @override
  State<PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<PulsingDots> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final offset = i * 0.167;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(3)),
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) {
              final phase = (_ctrl.value - offset) % 1.0;
              final t = math.sin(phase * math.pi);
              final opacity = 0.3 + t * 0.7;
              return Opacity(
                opacity: opacity,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryAccent.withValues(alpha: 0.50)),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class SpinningIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color color;
  final Duration period;

  const SpinningIcon({
    super.key,
    required this.icon,
    required this.size,
    required this.color,
    this.period = const Duration(milliseconds: 1500),
  });

  @override
  State<SpinningIcon> createState() => _SpinningIconState();
}

class _SpinningIconState extends State<SpinningIcon> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.period)..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Transform.rotate(angle: _ctrl.value * 2 * math.pi, child: child),
      child: Icon(widget.icon, size: widget.size, color: widget.color),
    );
  }
}

class SubBottomSheet extends StatelessWidget {
  final Widget child;
  final Widget? headerAction;
  const SubBottomSheet({super.key, required this.child, this.headerAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: context.scaleWidth(24),
        right: context.scaleWidth(24),
        top: context.scaleHeight(20),
        bottom: MediaQuery.of(context).padding.bottom + context.scaleHeight(40),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1a3550),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.10))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 32), // Placeholder to center handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.20), borderRadius: BorderRadius.circular(50)),
              ),
              if (headerAction != null) headerAction! else const SizedBox(width: 32),
            ],
          ),
          SizedBox(height: context.scaleHeight(20)),
          child,
        ],
      ),
    );
  }
}

class GradientCtaBackdrop extends StatelessWidget {
  final Widget child;
  const GradientCtaBackdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.background.withValues(alpha: 0), AppColors.background],
          stops: const [0.0, 0.4],
        ),
      ),
      padding: EdgeInsets.only(
        left: context.scaleWidth(20),
        right: context.scaleWidth(20),
        top: context.scaleHeight(16),
        bottom: context.scaleHeight(32) + MediaQuery.of(context).padding.bottom,
      ),
      child: child,
    );
  }
}


