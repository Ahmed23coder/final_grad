import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/mvvm/view_model_builder.dart';
import 'package:briefly/src/core/routes/app_router.dart';
import 'package:briefly/src/core/utils/app_animations.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';
import '../profile/cubits/subscription/confirmation_viewmodel.dart';
import 'widgets/standard_subscription_header.dart';
import 'widgets/subscription_widgets.dart';

class ConfirmationView extends StatefulWidget {
  const ConfirmationView({super.key});

  @override
  State<ConfirmationView> createState() => _ConfirmationViewState();
}

class _ConfirmationViewState extends State<ConfirmationView> {
  Timer? _redirectTimer;
  int _secondsRemaining = 5;
  bool _navigationStarted = false;

  void _startRedirectTimer() {
    if (_redirectTimer != null || _navigationStarted) return;

    _redirectTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_secondsRemaining > 1) {
          _secondsRemaining--;
        } else {
          _navigationStarted = true;
          timer.cancel();
          context.go(AppRouter.shell);
        }
      });
    });
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConfirmationViewModel>.reactive(
      viewModelBuilder: () => ConfirmationViewModel(),
      builder: (context, vm, _) {
        if (vm.isSuccess) {
          _startRedirectTimer();
          return _buildSuccessScreen(context);
        }
        if (vm.isProcessing) return _buildProcessingScreen(context);
        return _buildReviewScreen(context, vm);
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // STATE 1: REVIEW
  // ═══════════════════════════════════════════════════════════════
  Widget _buildReviewScreen(BuildContext context, ConfirmationViewModel vm) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const StandardSubscriptionHeader(
              title: 'Confirm Payment',
              subtitle: 'Review before you subscribe',
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaleWidth(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildOrderSummary(context),
                    SizedBox(height: context.scaleHeight(20)),
                    _buildPaymentDetails(context),
                    SizedBox(height: context.scaleHeight(20)),
                    _buildWhatYoullUnlock(context),
                    SizedBox(height: context.scaleHeight(24)),
                    TermsCheckbox(
                      isChecked: vm.isAgreed,
                      onChanged: (val) => vm.toggleAgreement(val),
                    ),
                    SizedBox(height: context.scaleHeight(24)),
                    _buildGuarantee(context),
                    SizedBox(height: context.scaleHeight(100)),
                  ],
                ),
              ),
            ),
            _buildFixedCTA(context, vm),
          ],
        ),
      ),
    );
  }

  // ─── A. Order Summary ───
  Widget _buildOrderSummary(BuildContext context) {
    return PageEntranceAnimation(
      delay: const Duration(milliseconds: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SubSectionLabel('ORDER SUMMARY'),
          SizedBox(height: context.scaleHeight(16)),
          SubCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(context.scaleWidth(20)),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent.withValues(
                            alpha: 0.10,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.primaryAccent.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          LucideIcons.sparkles,
                          size: 24,
                          color: AppColors.primaryAccent,
                        ),
                      ),
                      SizedBox(width: context.scaleWidth(16)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Annual Premium',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: context.scaleFontSize(18),
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: context.scaleHeight(4)),
                            const BadgePill(
                              label: 'Special Offer',
                              type: BadgeType.discount,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 1, color: AppColors.silver08),
                Padding(
                  padding: EdgeInsets.all(context.scaleWidth(20)),
                  child: Column(
                    children: [
                      _lineItem(context, 'Full Access Plan', '\$119.88'),
                      SizedBox(height: context.scaleHeight(12)),
                      _lineItem(
                        context,
                        'Annual Discount',
                        '-\$39.89',
                        valueColor: const Color(0xFF4ade80),
                      ),
                      SizedBox(height: context.scaleHeight(20)),
                      Row(
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.scaleFontSize(16),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '\$79.99',
                            style: TextStyle(
                              fontFamily: 'Newsreader',
                              fontSize: context.scaleFontSize(28),
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _lineItem(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.scaleFontSize(12),
            color: AppColors.primaryAccent.withValues(alpha: 0.60),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.scaleFontSize(12),
            color: valueColor ?? Colors.white,
          ),
        ),
      ],
    );
  }

  // ─── B. Payment Details ───
  Widget _buildPaymentDetails(BuildContext context) {
    return PageEntranceAnimation(
      delay: const Duration(milliseconds: 160),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SubSectionLabel('PAYMENT DETAILS'),
          SizedBox(height: context.scaleHeight(12)),
          SubCard(
            padding: EdgeInsets.all(context.scaleWidth(20)),
            child: Column(
              children: [
                _detailRow(
                  context,
                  LucideIcons.creditCard,
                  'Card',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _visaBadge(context),
                      SizedBox(width: context.scaleWidth(8)),
                      Text(
                        '•••• 4242',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.scaleFontSize(12),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.scaleHeight(14)),
                _detailRow(
                  context,
                  LucideIcons.calendar,
                  'Starts',
                  value: 'Apr 8, 2026',
                ),
                SizedBox(height: context.scaleHeight(14)),
                _detailRow(
                  context,
                  LucideIcons.calendar,
                  'Next renewal',
                  value: 'Apr 8, 2027',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
    BuildContext context,
    IconData icon,
    String label, {
    String? value,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.silverPlaceholder),
        SizedBox(width: context.scaleWidth(12)),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.scaleFontSize(13),
              color: AppColors.silverSecondaryLabel,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        if (trailing != null) trailing,
        if (value != null)
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.scaleFontSize(13),
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _visaBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleWidth(8),
        vertical: context.scaleHeight(2),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1a73e8).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF1a73e8).withValues(alpha: 0.25),
        ),
      ),
      child: const Text(
        'VISA',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1a73e8),
        ),
      ),
    );
  }

  // ─── C. What You'll Unlock ───
  Widget _buildWhatYoullUnlock(BuildContext context) {
    final items = [
      {
        'icon': LucideIcons.sparkles,
        'label': 'AI Summaries',
        'color': const Color(0xFFa78bfa),
      },
      {
        'icon': LucideIcons.shield,
        'label': 'Fact Checks',
        'color': const Color(0xFF22d3ee),
      },
      {
        'icon': LucideIcons.infinity,
        'label': 'Vault Storage',
        'color': const Color(0xFFf59e0b),
      },
      {
        'icon': LucideIcons.crown,
        'label': 'Premium',
        'color': const Color(0xFFC0C0C0),
      },
      {
        'icon': LucideIcons.zap,
        'label': 'Priority News',
        'color': const Color(0xFFf97316),
      },
      {
        'icon': LucideIcons.bookOpen,
        'label': 'Offline Read',
        'color': const Color(0xFF34d399),
      },
      {
        'icon': LucideIcons.star,
        'label': 'Intel Reports',
        'color': const Color(0xFFec4899),
      },
      {
        'icon': LucideIcons.headphones,
        'label': 'Support',
        'color': const Color(0xFF8b5cf6),
      },
    ];
    return PageEntranceAnimation(
      delay: const Duration(milliseconds: 220),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SubSectionLabel("WHAT YOU'LL UNLOCK"),
          SizedBox(height: context.scaleHeight(12)),
          SubCard(
            padding: EdgeInsets.all(context.scaleWidth(16)),
            child: Wrap(
              spacing: context.scaleWidth(12),
              runSpacing: context.scaleHeight(12),
              children: items.map((item) {
                final color = item['color'] as Color;
                return SizedBox(
                  width:
                      (MediaQuery.of(context).size.width -
                          context.scaleWidth(20) * 2 -
                          context.scaleWidth(16) * 2 -
                          context.scaleWidth(12)) /
                      2,
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          item['icon'] as IconData,
                          size: 13,
                          color: color,
                        ),
                      ),
                      SizedBox(width: context.scaleWidth(8)),
                      Expanded(
                        child: Text(
                          item['label'] as String,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.scaleFontSize(10),
                            color: AppColors.primaryAccent.withValues(
                              alpha: 0.60,
                            ),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ─── E. Guarantee ───
  Widget _buildGuarantee(BuildContext context) {
    return PageEntranceAnimation(
      delay: const Duration(milliseconds: 340),
      child: Container(
        padding: EdgeInsets.all(context.scaleWidth(16)),
        decoration: BoxDecoration(
          color: const Color(0xFF34d399).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: const Color(0xFF34d399).withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF34d399).withValues(alpha: 0.10),
              ),
              alignment: Alignment.center,
              child: const Icon(
                LucideIcons.shieldCheck,
                size: 16,
                color: Color(0xFF34d399),
              ),
            ),
            SizedBox(width: context.scaleWidth(12)),
            Expanded(
              child: Text(
                '7-Day Money-Back Guarantee · Cancel anytime',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.scaleFontSize(12),
                  color: const Color(0xFF34d399).withValues(alpha: 0.80),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── F. Fixed CTA ───
  Widget _buildFixedCTA(BuildContext context, ConfirmationViewModel vm) {
    return GradientCtaBackdrop(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SubPrimaryButton(
            label: 'Subscribe Now (\$79.99)',
            iconRight: LucideIcons.shieldCheck,
            enabled: vm.isAgreed,
            onTap: vm.isAgreed ? () => vm.processPayment() : null,
          ),
          SizedBox(height: context.scaleHeight(12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.lock,
                size: 10,
                color: AppColors.silverSecondaryLabel,
              ),
              SizedBox(width: context.scaleWidth(6)),
              Text(
                'Secured with SSL Encryption',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.scaleFontSize(11),
                  color: AppColors.silverSecondaryLabel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // STATE 2: PROCESSING
  // ═══════════════════════════════════════════════════════════════
  Widget _buildProcessingScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryAccent.withValues(alpha: 0.08),
                border: Border.all(
                  color: AppColors.primaryAccent.withValues(alpha: 0.15),
                ),
              ),
              alignment: Alignment.center,
              child: const SpinningIcon(
                icon: LucideIcons.loaderCircle,
                size: 32,
                color: AppColors.primaryAccent,
              ),
            ),
            SizedBox(height: context.scaleHeight(24)),
            Text(
              'Processing Payment...',
              style: TextStyle(
                fontFamily: 'Newsreader',
                fontSize: context.scaleFontSize(20),
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: context.scaleHeight(8)),
            Text(
              'Securing your subscription',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.scaleFontSize(14),
                color: AppColors.primaryAccent.withValues(alpha: 0.50),
              ),
            ),
            SizedBox(height: context.scaleHeight(24)),
            const PulsingDots(),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // STATE 3: SUCCESS
  // ═══════════════════════════════════════════════════════════════
  Widget _buildSuccessScreen(BuildContext context) {
    final receiptNum = (100000 + Random().nextInt(900000)).toString();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _ConfettiOverlay(),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(32)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PageEntranceAnimation(
                    delay: const Duration(milliseconds: 100),
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFa78bfa).withValues(alpha: 0.20),
                            const Color(0xFF4ade80).withValues(alpha: 0.10),
                          ],
                        ),
                        border: Border.all(
                          color: const Color(
                            0xFF4ade80,
                          ).withValues(alpha: 0.20),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        LucideIcons.circleCheck,
                        size: 48,
                        color: Color(0xFF4ade80),
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(24)),
                  PageEntranceAnimation(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      'Welcome to Premium!',
                      style: TextStyle(
                        fontFamily: 'Newsreader',
                        fontSize: context.scaleFontSize(24),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(8)),
                  PageEntranceAnimation(
                    delay: const Duration(milliseconds: 260),
                    child: Text(
                      'Your Annual Premium subscription is now active.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.scaleFontSize(14),
                        color: AppColors.primaryAccent.withValues(alpha: 0.50),
                        height: 1.6,
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(28)),
                  PageEntranceAnimation(
                    delay: const Duration(milliseconds: 320),
                    child: SubCard(
                      padding: EdgeInsets.all(context.scaleWidth(20)),
                      radius: 24,
                      child: Column(
                        children: [
                          _receiptRow(context, 'Receipt #', receiptNum),
                          SizedBox(height: context.scaleHeight(12)),
                          _receiptRow(context, 'Plan', 'Annual Premium'),
                          SizedBox(height: context.scaleHeight(12)),
                          _receiptRow(context, 'Amount', '\$79.99'),
                          SizedBox(height: context.scaleHeight(12)),
                          _receiptRow(context, 'Next renewal', 'Apr 8, 2027'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(28)),
                  PageEntranceAnimation(
                    delay: const Duration(milliseconds: 380),
                    child: SubPrimaryButton(
                      label: 'Start Exploring',
                      onTap: () => context.go(AppRouter.shell),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(12)),
                  PageEntranceAnimation(
                    delay: const Duration(milliseconds: 400),
                    child: Text(
                      'Redirecting to home in $_secondsRemaining seconds...',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.scaleFontSize(12),
                        color: AppColors.primaryAccent.withValues(alpha: 0.35),
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(24)),
                  PageEntranceAnimation(
                    delay: const Duration(milliseconds: 420),
                    child: SubSecondaryOutlinedButton(
                      label: 'View Subscription Details',
                      onTap: () => context.push(AppRouter.subscriptionManage),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _receiptRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.scaleFontSize(12),
            color: AppColors.primaryAccent.withValues(alpha: 0.50),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.scaleFontSize(12),
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// CONFETTI OVERLAY
// ────────────────────────────────────────────────────────────────────────────
class _ConfettiOverlay extends StatefulWidget {
  @override
  State<_ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<_ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final _rng = Random();
  late final List<_ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..forward();
    _particles = List.generate(40, (_) => _generateParticle());
  }

  _ConfettiParticle _generateParticle() {
    return _ConfettiParticle(
      x: _rng.nextDouble(),
      y: -_rng.nextDouble() * 0.3,
      size: 4 + _rng.nextDouble() * 7,
      speed: 0.3 + _rng.nextDouble() * 0.7,
      color: [
        const Color(0xFFa78bfa),
        const Color(0xFF22d3ee),
        const Color(0xFF4ade80),
        const Color(0xFFfbbf24),
        const Color(0xFFf87171),
        const Color(0xFFC0C0C0),
        const Color(0xFFec4899),
        const Color(0xFFf97316),
      ][_rng.nextInt(8)],
      drift: (_rng.nextDouble() - 0.5) * 0.15,
    );
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
      builder: (context, _) {
        return IgnorePointer(
          child: CustomPaint(
            size: Size.infinite,
            painter: _ConfettiPainter(_particles, _ctrl.value),
          ),
        );
      },
    );
  }
}

class _ConfettiParticle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final Color color;
  final double drift;

  const _ConfettiParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
    required this.drift,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double t;

  _ConfettiPainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final x = (p.x + p.drift * t) * size.width;
      final y = (p.y + p.speed * t) * size.height;
      final opacity = (1.0 - t).clamp(0.0, 1.0);
      final paint = Paint()..color = p.color.withValues(alpha: opacity * 0.8);
      canvas.drawCircle(Offset(x, y), p.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.t != t;
}
