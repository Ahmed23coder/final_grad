import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/utils/responsive_util.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _introCtrl;
  late final AnimationController _glowCtrl;
  late final AnimationController _loadingCtrl;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subtitleOpacity;
  late final Animation<double> _glowScale;
  late final Animation<double> _glowOpacity;
  late final Animation<double> _loadingWidth;

  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _introCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // Logo Fade and Scale
    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _introCtrl,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOutBack),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introCtrl,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    // Title Fade-Up
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introCtrl,
        curve: const Interval(0.30, 0.60, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _introCtrl,
            curve: const Interval(0.30, 0.60, curve: Curves.easeOutCubic),
          ),
        );

    // Subtitle Fade-In
    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introCtrl,
        curve: const Interval(0.375, 0.625, curve: Curves.easeOut),
      ),
    );

    // Ambient Glow (Independent looping)
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _glowScale = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
    _glowOpacity = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

    // Progress Bar Sweep
    _loadingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _loadingWidth = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _loadingCtrl, curve: Curves.easeInOut));

    // Trigger animations. Navigate as soon as the intro animation finishes
    // (or after a hard 2.5s ceiling, whichever comes first) — instead of
    // waiting on a fixed delay, which felt like a freeze on cold-start
    // debug builds.
    _introCtrl.forward().whenComplete(_goNext);
    _loadingCtrl.forward();
    _glowCtrl.repeat(reverse: true);

    // Safety net: if for any reason the intro controller never completes,
    // navigate anyway after a hard timeout.
    Future.delayed(const Duration(milliseconds: 2500), _goNext);
  }

  void _goNext() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    try {
      context.go(AppRouter.bootstrap);
    } catch (e, stack) {
      // Surface routing errors instead of silently freezing the splash.
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Navigation Error'),
          content: SingleChildScrollView(child: Text('$e\n$stack')),
        ),
      );
    }
  }

  @override
  void dispose() {
    _introCtrl.dispose();
    _glowCtrl.dispose();
    _loadingCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Glow
            Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              child: AnimatedBuilder(
                animation: _glowCtrl,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _glowScale.value,
                    child: Opacity(opacity: _glowOpacity.value, child: child!),
                  );
                },
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 32.0, sigmaY: 32.0),
                  child: Container(
                    width: context.scaleWidth(260.0),
                    height: context.scaleWidth(260.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryAccent.withAlpha(
                        38,
                      ), // ~0.15 opacity
                    ),
                  ),
                ),
              ),
            ),

            // Foreground logo group
            Positioned(
              top: MediaQuery.of(context).size.height * 0.42,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo Scale-In
                  AnimatedBuilder(
                    animation: _introCtrl,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScale.value,
                        child: Opacity(
                          opacity: _logoOpacity.value,
                          child: child!,
                        ),
                      );
                    },
                    child: Container(
                      width: context.scaleWidth(80),
                      height: context.scaleWidth(80),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(13), // ~0.05 opacity
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.white.withAlpha(51), // ~0.2 opacity
                          width: 1.185,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/briefly_logo.png',
                        width: context.scaleWidth(40),
                        height: context.scaleWidth(40),
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.newspaper,
                          color: AppColors.foreground,
                          size: context.scaleWidth(40),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(24)),

                  // Title Fade-Up
                  AnimatedBuilder(
                    animation: _introCtrl,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _titleSlide,
                        child: Opacity(
                          opacity: _titleOpacity.value,
                          child: child!,
                        ),
                      );
                    },
                    child: Text(
                      'Briefly',
                      style: GoogleFonts.playfairDisplay(
                        color: AppColors.foreground,
                        fontSize: context.scaleFontSize(32),
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(8)),

                  // Subtitle Fade-In
                  AnimatedBuilder(
                    animation: _introCtrl,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _subtitleOpacity.value,
                        child: child!,
                      );
                    },
                    child: Text(
                      'INTELLIGENCE',
                      style: TextStyle(
                        color: AppColors.primaryAccent,
                        fontSize: context.scaleFontSize(12),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Progress Bar Sweep
            Positioned(
              bottom: context.scaleHeight(72),
              child: AnimatedBuilder(
                animation: _loadingCtrl,
                builder: (_, __) => Container(
                  width: 107.6 * _loadingWidth.value,
                  height: 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.primaryAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
