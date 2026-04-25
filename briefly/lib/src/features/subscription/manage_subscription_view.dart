import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/mvvm/view_model_builder.dart';
import 'package:briefly/src/core/utils/app_animations.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';
import 'package:briefly/src/domain/repositories/profile_repository.dart';
import '../profile/cubits/subscription/manage_subscription_viewmodel.dart';
import 'widgets/standard_subscription_header.dart';
import 'widgets/subscription_widgets.dart';

class ManageSubscriptionView extends StatelessWidget {
  const ManageSubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ManageSubscriptionViewModel>.reactive(
      viewModelBuilder: () =>
          ManageSubscriptionViewModel(context.read<ProfileRepository>()),
      onModelReady: (vm) => vm.init(),
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: vm.isBusy
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFC0C0C0)),
                )
              : SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      const StandardSubscriptionHeader(
                        title: 'Manage Subscription',
                        subtitle: 'Review and manage your plan',
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
                              _buildHeroCard(context, vm),
                              SizedBox(height: context.scaleHeight(20)),
                              _buildQuickActions(context),
                              SizedBox(height: context.scaleHeight(20)),
                              _buildPremiumBenefits(context),
                              SizedBox(height: context.scaleHeight(20)),
                              _buildUsageStats(context),
                              SizedBox(height: context.scaleHeight(20)),
                              _buildRecentBilling(context),
                              SizedBox(height: context.scaleHeight(20)),
                              _buildDangerZone(context, vm),
                              SizedBox(height: context.scaleHeight(40)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  // ═══ A. HERO CARD ═══
  Widget _buildHeroCard(BuildContext context, ManageSubscriptionViewModel vm) {
    return Column(
      children: [
        SubHeroBanner(
          title: 'Premium Monthly',
          subtitle: 'Active since Jan 15, 2025',
          icon: LucideIcons.crown,
          themeColor: AppColors.primaryAccent,
        ),
        SizedBox(height: context.scaleHeight(16)),
        SubCard(
          padding: EdgeInsets.all(context.scaleWidth(20)),
          child: Column(
            children: [
              _heroDetailRow(
                context,
                LucideIcons.calendar,
                'Next billing date',
                'May 8, 2026',
              ),
              SizedBox(height: context.scaleHeight(16)),
              _heroDetailRow(
                context,
                LucideIcons.creditCard,
                'Payment method',
                '•••• 4242',
              ),
              SizedBox(height: context.scaleHeight(16)),
              _heroDetailRow(
                context,
                LucideIcons.refreshCcw,
                'Auto-renew',
                'Enabled',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _heroDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
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

  // ═══ B. QUICK ACTIONS ═══
  Widget _buildQuickActions(BuildContext context) {
    return PageEntranceAnimation(
      delay: const Duration(milliseconds: 160),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SubSectionLabel('QUICK ACTIONS'),
          SizedBox(height: context.scaleHeight(12)),
          SubCard(
            child: Column(
              children: [
                QuickActionRow(
                  icon: LucideIcons.sparkles,
                  color: const Color(0xFFa78bfa),
                  label: 'Upgrade to Annual',
                  subtitle: 'Save 33% — \$79.99/year',
                  onTap: () =>
                      context.push('/profile/subscription'),
                ),
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
                QuickActionRow(
                  icon: LucideIcons.creditCard,
                  color: const Color(0xFF22d3ee),
                  label: 'Payment Methods',
                  subtitle: 'Manage cards and billing',
                  onTap: () => context.push(
                    '/profile/subscription/payment',
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
                QuickActionRow(
                  icon: LucideIcons.refreshCcw,
                  color: const Color(0xFFf59e0b),
                  label: 'Restore Purchases',
                  subtitle: 'Recover previous subscriptions',
                  onTap: () =>
                      context.push('/profile/subscription/restore'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══ C. PREMIUM BENEFITS ═══
  Widget _buildPremiumBenefits(BuildContext context) {
    final benefits = [
      'Unlimited AI Summaries',
      'Unlimited Fact Checks',
      'Unlimited Vault Storage',
      'Ad-Free Experience',
      'Priority Breaking News',
    ];
    return PageEntranceAnimation(
      delay: const Duration(milliseconds: 220),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SubSectionLabel('YOUR PREMIUM BENEFITS'),
          SizedBox(height: context.scaleHeight(16)),
          SubCard(
            padding: EdgeInsets.all(context.scaleWidth(20)),
            child: Column(
              children: benefits.asMap().entries.map((e) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: e.key < benefits.length - 1
                        ? context.scaleHeight(16)
                        : 0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.circleCheck,
                        size: 16,
                        color: Color(0xFF4ade80),
                      ),
                      SizedBox(width: context.scaleWidth(14)),
                      Expanded(
                        child: Text(
                          e.value,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.scaleFontSize(14),
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
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

  // ═══ D. MONTHLY USAGE STATS ═══
  Widget _buildUsageStats(BuildContext context) {
    final stats = [
      {
        'color': const Color(0xFFa78bfa),
        'label': 'AI Summaries',
        'value': '127',
      },
      {'color': const Color(0xFF22d3ee), 'label': 'Fact Checks', 'value': '43'},
      {
        'color': const Color(0xFFf59e0b),
        'label': 'Articles Saved',
        'value': '38',
      },
      {
        'color': const Color(0xFF34d399),
        'label': 'Reading Time',
        'value': '14h 32m',
      },
    ];
    return PageEntranceAnimation(
      delay: const Duration(milliseconds: 280),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SubSectionLabel("THIS MONTH'S USAGE"),
          SizedBox(height: context.scaleHeight(16)),
          SubCard(
            padding: EdgeInsets.all(context.scaleWidth(20)),
            child: Column(
              children: stats.asMap().entries.map((entry) {
                final s = entry.value;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key < stats.length - 1
                        ? context.scaleHeight(20)
                        : 0,
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: s['color'] as Color,
                        ),
                      ),
                      SizedBox(width: context.scaleWidth(12)),
                      Expanded(
                        child: Text(
                          s['label'] as String,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.scaleFontSize(12),
                            color: AppColors.silverPlaceholder.withValues(
                              alpha: 0.60,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        s['value'] as String,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.scaleFontSize(14),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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

  // ═══ E. RECENT BILLING ═══
  Widget _buildRecentBilling(BuildContext context) {
    final bills = [
      {'date': 'Apr 8, 2026', 'sub': 'Premium Monthly', 'amount': '\$9.99'},
      {'date': 'Mar 8, 2026', 'sub': 'Premium Monthly', 'amount': '\$9.99'},
      {'date': 'Feb 8, 2026', 'sub': 'Premium Monthly', 'amount': '\$9.99'},
    ];
    return PageEntranceAnimation(
      delay: const Duration(milliseconds: 340),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SubSectionLabel('RECENT BILLING'),
          SizedBox(height: context.scaleHeight(16)),
          SubCard(
            child: Column(
              children: bills.asMap().entries.map((entry) {
                final b = entry.value;
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaleWidth(20),
                        vertical: context.scaleHeight(18),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  b['date']!,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: context.scaleFontSize(15),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: context.scaleHeight(4)),
                                Text(
                                  b['sub']!,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: context.scaleFontSize(11),
                                    color: AppColors.silverPlaceholder,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                b['amount']!,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: context.scaleFontSize(15),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: context.scaleHeight(4)),
                              const BadgePill(
                                label: 'Paid',
                                type: BadgeType.active,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (entry.key < bills.length - 1)
                      Container(
                        height: 1,
                        color: AppColors.silver08,
                        margin: EdgeInsets.symmetric(
                          horizontal: context.scaleWidth(20),
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ═══ F. DANGER ZONE ═══
  Widget _buildDangerZone(
    BuildContext context,
    ManageSubscriptionViewModel vm,
  ) {
    return PageEntranceAnimation(
      delay: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SubSectionLabel('DANGER ZONE'),
          SizedBox(height: context.scaleHeight(12)),
          CancelDangerRow(
            label: 'Cancel Subscription',
            subtitle: "You'll retain access until May 8, 2026",
            onTap: () => _showCancelSheet(context, vm),
          ),
        ],
      ),
    );
  }

  // ═══ G. CANCEL BOTTOM SHEET ═══
  void _showCancelSheet(BuildContext context, ManageSubscriptionViewModel vm) {
    vm.resetCancel();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return _CancelBottomSheet(vm: vm, parentContext: ctx);
      },
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// CANCEL BOTTOM SHEET (Stateful for reason pill selection + confirmed phase)
// ────────────────────────────────────────────────────────────────────────────
class _CancelBottomSheet extends StatefulWidget {
  final ManageSubscriptionViewModel vm;
  final BuildContext parentContext;
  const _CancelBottomSheet({required this.vm, required this.parentContext});

  @override
  State<_CancelBottomSheet> createState() => _CancelBottomSheetState();
}

class _CancelBottomSheetState extends State<_CancelBottomSheet> {
  String? _selectedReason;
  bool _confirmed = false;

  static const _reasons = [
    'Too expensive',
    'Not using enough',
    'Found an alternative',
    'Missing features',
    'Other',
  ];

  void _confirm() async {
    setState(() => _confirmed = true);
    // Auto-dismiss after 2.5 seconds
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: context.scaleWidth(24),
        right: context.scaleWidth(24),
        top: context.scaleHeight(12),
        bottom: MediaQuery.of(context).padding.bottom + context.scaleHeight(34),
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.silver08,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          SizedBox(height: context.scaleHeight(24)),
          if (_confirmed)
            _buildConfirmedView(context)
          else
            _buildDefaultView(context),
        ],
      ),
    );
  }

  Widget _buildDefaultView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Warning icon
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.destructive.withValues(alpha: 0.10),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.destructive.withValues(alpha: 0.20),
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: const Icon(
            LucideIcons.triangleAlert,
            size: 28,
            color: AppColors.destructive,
          ),
        ),
        SizedBox(height: context.scaleHeight(20)),
        Text(
          'Cancel Premium?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Newsreader',
            fontSize: context.scaleFontSize(24),
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: context.scaleHeight(10)),
        Text(
          "You'll lose access to unlimited summaries, fact checks, ad-free reading, and all premium features.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.scaleFontSize(14),
            color: AppColors.silverSecondaryLabel,
            height: 1.6,
          ),
        ),
        SizedBox(height: context.scaleHeight(28)),
        const SubSectionLabel('REASON FOR CANCELLING'),
        SizedBox(height: context.scaleHeight(12)),
        // Reason pills
        ..._reasons.map((r) {
          final isSelected = _selectedReason == r;
          return CancelReasonPill(
            label: r,
            isSelected: isSelected,
            onTap: () => setState(() => _selectedReason = r),
          );
        }),
        SizedBox(height: context.scaleHeight(20)),
        // Confirm button
        SubDestructiveButton(
          label: 'Confirm Cancellation',
          enabled: _selectedReason != null,
          onTap: _confirm,
        ),
        SizedBox(height: context.scaleHeight(12)),
        // Keep button
        SubSecondaryOutlinedButton(
          label: 'Keep my plan',
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildConfirmedView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFf59e0b).withValues(alpha: 0.10),
            border: Border.all(
              color: const Color(0xFFf59e0b).withValues(alpha: 0.20),
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(
            LucideIcons.circleCheck,
            size: 36,
            color: Color(0xFFf59e0b),
          ),
        ),
        SizedBox(height: context.scaleHeight(20)),
        Text(
          'Subscription Cancelled',
          style: TextStyle(
            fontFamily: 'Newsreader',
            fontSize: context.scaleFontSize(22),
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: context.scaleHeight(10)),
        Text(
          "You'll have access until May 8, 2026",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.scaleFontSize(15),
            color: AppColors.silverSecondaryLabel,
          ),
        ),
      ],
    );
  }
}
