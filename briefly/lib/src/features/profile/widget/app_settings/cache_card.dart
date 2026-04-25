import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/theme/app_text_styles.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';
import 'package:briefly/src/core/theme/app_radius.dart';

class CacheCard extends StatelessWidget {
  final String size;
  final bool isCleared;
  final VoidCallback onClear;

  const CacheCard({
    super.key,
    required this.size,
    required this.isCleared,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.scaleWidth(20)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.settingsGroup,
        border: Border.all(
          color: AppColors.silverBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.scaleWidth(8)),
                decoration: BoxDecoration(
                  color: AppColors.accentBlue.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  LucideIcons.hardDrive,
                  size: context.scaleWidth(18),
                  color: AppColors.accentBlue,
                ),
              ),
              SizedBox(width: context.scaleWidth(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cache Storage',
                      style: AppTextStyles.cardLabel(context),
                    ),
                    Text(
                      'Free up space by clearing cached data',
                      style: AppTextStyles.cardDescription(context),
                    ),
                  ],
                ),
              ),
              Text(
                size,
                style: AppTextStyles.h3(context),
              ),
            ],
          ),
          SizedBox(height: context.scaleHeight(20)),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              height: context.scaleHeight(8), // scaled height
              width: double.infinity,
              color: Colors.white.withValues(alpha: 0.08), // Track: white/8
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: isCleared ? 0.0 : 0.65, // Simulated fill
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryAccent.withValues(alpha: 0.5), // Fill: silver/50
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: context.scaleHeight(12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Includes images, snippets, and articles',
                  style: AppTextStyles.microText(context),
                ),
              ),
              GestureDetector(
                onTap: isCleared ? null : onClear,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scaleWidth(16),
                    vertical: context.scaleHeight(8),
                  ),
                  decoration: BoxDecoration(
                    color: isCleared 
                        ? Colors.transparent 
                        : AppColors.foreground.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(50), // Stadium pill
                    border: Border.all(
                      color: isCleared 
                          ? Colors.transparent 
                          : AppColors.foreground.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isCleared ? LucideIcons.check : LucideIcons.trash2,
                        size: context.scaleWidth(14),
                        color: isCleared ? const Color(0xFF10B981) : AppColors.foreground,
                      ),
                      SizedBox(width: context.scaleWidth(6)),
                      Text(
                        isCleared ? 'Cache Cleared!' : 'Clear Cache',
                        style: AppTextStyles.microBold(context).copyWith(
                          color: isCleared ? const Color(0xFF10B981) : AppColors.foreground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
