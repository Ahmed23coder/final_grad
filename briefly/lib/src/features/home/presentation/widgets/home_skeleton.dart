import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_util.dart';
import '../../../../core/widgets/shimmer_box.dart';

/// Skeleton placeholder for the home feed shown while data is loading.
/// Layout mirrors the real feed: greeting, featured hero card, trending
/// carousel, hot-topic header and rows.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final hPad = EdgeInsets.symmetric(horizontal: context.scaleWidth(20));

    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
        // Greeting block
        Padding(
          padding: hPad.copyWith(
            top: context.scaleHeight(16),
            bottom: context.scaleHeight(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(
                width: context.scaleWidth(220),
                height: context.scaleHeight(28),
                radius: 6,
              ),
              SizedBox(height: context.scaleHeight(8)),
              ShimmerBox(
                width: context.scaleWidth(160),
                height: context.scaleHeight(14),
                radius: 4,
              ),
            ],
          ),
        ),

        // Featured hero card
        Padding(
          padding: hPad,
          child: ShimmerBox(
            height: context.scaleHeight(208),
            width: double.infinity,
            radius: 24,
          ),
        ),

        SizedBox(height: context.scaleHeight(24)),

        // Trending carousel
        SizedBox(
          height: context.scaleHeight(200),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(20)),
            itemCount: 3,
            separatorBuilder: (_, __) =>
                SizedBox(width: context.scaleWidth(12)),
            itemBuilder: (_, __) => SizedBox(
              width: context.scaleWidth(144),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(
                    width: context.scaleWidth(144),
                    height: context.scaleHeight(96),
                    radius: 16,
                  ),
                  SizedBox(height: context.scaleHeight(8)),
                  ShimmerBox(
                    width: context.scaleWidth(140),
                    height: context.scaleHeight(12),
                    radius: 4,
                  ),
                  SizedBox(height: context.scaleHeight(4)),
                  ShimmerBox(
                    width: context.scaleWidth(100),
                    height: context.scaleHeight(10),
                    radius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: context.scaleHeight(24)),

        // Hot topic header
        Padding(
          padding: hPad,
          child: Row(
            children: [
              ShimmerBox(
                width: context.scaleWidth(28),
                height: context.scaleWidth(28),
                radius: 14,
              ),
              SizedBox(width: context.scaleWidth(8)),
              ShimmerBox(
                width: context.scaleWidth(96),
                height: context.scaleHeight(20),
                radius: 6,
              ),
              const Spacer(),
              ShimmerBox(
                width: context.scaleWidth(56),
                height: context.scaleHeight(14),
                radius: 4,
              ),
            ],
          ),
        ),

        SizedBox(height: context.scaleHeight(16)),

        // Hot topic rows
        ...List.generate(
          4,
          (_) => Padding(
            padding: EdgeInsets.only(
              left: context.scaleWidth(20),
              right: context.scaleWidth(20),
              bottom: context.scaleHeight(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                  width: context.scaleWidth(80),
                  height: context.scaleWidth(80),
                  radius: 16,
                ),
                SizedBox(width: context.scaleWidth(16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(
                        width: context.scaleWidth(60),
                        height: context.scaleHeight(10),
                        radius: 4,
                      ),
                      SizedBox(height: context.scaleHeight(6)),
                      ShimmerBox(
                        width: double.infinity,
                        height: context.scaleHeight(14),
                        radius: 4,
                      ),
                      SizedBox(height: context.scaleHeight(6)),
                      ShimmerBox(
                        width: context.scaleWidth(180),
                        height: context.scaleHeight(14),
                        radius: 4,
                      ),
                      SizedBox(height: context.scaleHeight(10)),
                      ShimmerBox(
                        width: context.scaleWidth(120),
                        height: context.scaleHeight(10),
                        radius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

          SizedBox(height: context.scaleHeight(96)),
        ],
      ),
    );
  }
}
