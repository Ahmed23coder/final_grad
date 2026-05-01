import 'package:flutter/material.dart';

/// Hosts a single shared `AnimationController` so any number of [ShimmerBox]
/// descendants animate from the same tick — instead of each box spinning up
/// its own controller (which previously caused frame drops on screens with
/// many shimmer placeholders).
///
/// Wrap any subtree that contains shimmer boxes with `Shimmer(child: ...)`.
class Shimmer extends StatefulWidget {
  final Widget child;
  const Shimmer({super.key, required this.child});

  static Animation<double>? maybeOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_ShimmerScope>();
    return scope?.animation;
  }

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ShimmerScope(animation: _controller, child: widget.child);
  }
}

class _ShimmerScope extends InheritedWidget {
  final Animation<double> animation;

  const _ShimmerScope({required this.animation, required super.child});

  @override
  bool updateShouldNotify(_ShimmerScope oldWidget) =>
      animation != oldWidget.animation;
}

/// Lightweight shimmer effect — a sweeping gradient over a rounded rectangle.
/// No external dependency. Pulls its animation from the nearest [Shimmer]
/// ancestor so many boxes share one controller.
///
/// Falls back to a static placeholder color when no [Shimmer] ancestor is
/// found (cheap, but no animation).
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;
  final EdgeInsetsGeometry? margin;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.radius = 8,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final animation = Shimmer.maybeOf(context);
    if (animation == null) {
      return Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        // Sweep the highlight from left (-1) to right (+2) so the bright
        // band fully exits the box before looping.
        final t = animation.value * 3 - 1;
        return Container(
          width: width,
          height: height,
          margin: margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment(t - 0.3, 0),
              end: Alignment(t + 0.3, 0),
              colors: [
                Colors.white.withValues(alpha: 0.04),
                Colors.white.withValues(alpha: 0.10),
                Colors.white.withValues(alpha: 0.04),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}
