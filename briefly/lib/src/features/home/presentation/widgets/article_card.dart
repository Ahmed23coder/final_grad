import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_util.dart';

class ArticleCard extends StatelessWidget {
  final String title;
  final String category;
  final String source;
  final String timeAgo;
  final String? thumbnailUrl;
  final VoidCallback onTap;
  final bool isFlat;

  const ArticleCard({
    super.key,
    required this.title,
    required this.category,
    required this.source,
    required this.timeAgo,
    this.thumbnailUrl,
    required this.onTap,
    this.isFlat = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: EdgeInsets.all(isFlat ? 0 : 12),
          decoration: isFlat
              ? null
              : BoxDecoration(
                  color: AppColors.secondarySurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Container(
                width: context.scaleWidth(80),
                height: context.scaleWidth(80),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.withValues(alpha: 0.1),
                  image: thumbnailUrl != null && thumbnailUrl!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(thumbnailUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
              SizedBox(width: context.scaleWidth(16)),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.toUpperCase(),
                      style: AppTextStyles.caption(context).copyWith(
                        color: AppColors.accentBlue,
                        fontSize: context.scaleFontSize(10),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: context.scaleHeight(4)),
                    Text(
                      title,
                      style: AppTextStyles.h2(context).copyWith(
                        color: Colors.white,
                        fontSize: context.scaleFontSize(15),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.scaleHeight(8)),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            source,
                            style: AppTextStyles.caption(context).copyWith(
                              color: Colors.white.withValues(alpha: 0.3),
                              fontSize: context.scaleFontSize(11),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        CircleAvatar(
                          radius: 1.5,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeAgo,
                          style: AppTextStyles.caption(context).copyWith(
                            color: Colors.white.withValues(alpha: 0.3),
                            fontSize: context.scaleFontSize(11),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isFlat) ...[
                SizedBox(width: context.scaleWidth(8)),
                Icon(
                  LucideIcons.bookmark,
                  color: Colors.white.withValues(alpha: 0.2),
                  size: context.scaleWidth(18),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
