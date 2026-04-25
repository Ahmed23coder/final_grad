import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/mvvm/view_model_builder.dart';
import 'package:briefly/src/core/utils/app_animations.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';
import 'package:briefly/src/domain/repositories/profile_repository.dart';
import '../profile/cubits/subscription/upgrade_plan_viewmodel.dart';
import 'widgets/standard_subscription_header.dart';
import 'widgets/subscription_widgets.dart';

class UpgradePlanView extends StatelessWidget {
  const UpgradePlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpgradePlanViewModel>.reactive(
      viewModelBuilder: () =>
          UpgradePlanViewModel(context.read<ProfileRepository>()),
      onModelReady: (vm) => vm.init(),
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const StandardSubscriptionHeader(
                  title: 'Upgrade Plan',
                  subtitle: 'Choose the best plan for you',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scaleWidth(20),
                          ),
                          child: const SubHeroBanner(
                            title: 'Unlock Your Full Potential',
                            subtitle:
                                'Annual users save 33% and get exclusive features',
                            icon: LucideIcons.trendingUp,
                            themeColor: Color(0xFFa78bfa),
                          ),
                        ),
                        SizedBox(height: context.scaleHeight(20)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scaleWidth(20),
                          ),
                          child: _buildPlanCards(context, vm),
                        ),
                        SizedBox(height: context.scaleHeight(20)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scaleWidth(20),
                          ),
                          child: ComparisonToggleButton(
                            isExpanded: vm.isComparisonExpanded,
                            onTap: () => vm.toggleComparison(),
                          ),
                        ),
                        if (vm.isComparisonExpanded) ...[
                          SizedBox(height: context.scaleHeight(16)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.scaleWidth(20),
                            ),
                            child: _buildComparisonTable(context),
                          ),
                        ],
                        SizedBox(height: context.scaleHeight(20)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scaleWidth(20),
                          ),
                          child: _buildSecurityBanner(context),
                        ),
                        SizedBox(height: context.scaleHeight(20)),
                        TestimonialScroller(testimonials: _getTestimonials()),
                        SizedBox(height: context.scaleHeight(100)),
                      ],
                    ),
                  ),
                ),
                _buildFixedBottomCTA(context, vm),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══ B. PLAN CARDS ═══
  Widget _buildPlanCards(BuildContext context, UpgradePlanViewModel vm) {
    return Column(
      children: vm.plans.asMap().entries.map((entry) {
        final i = entry.key;
        final plan = entry.value;
        final isSelected = vm.selectedPlan?.id == plan.id;

        return PageEntranceAnimation(
          delay: Duration(milliseconds: 160 + i * 60),
          child: Padding(
            padding: EdgeInsets.only(bottom: context.scaleHeight(12)),
            child: PlanSelectionCard(
              name: plan.name,
              price: plan.displayPrice,
              interval: plan.interval,
              planColor: plan.color,
              icon: plan.icon,
              features: plan
                  .features, // Note: This standard widget doesn't distinguish excluded features yet, will show all features logic if needed
              isSelected: isSelected,
              isPopular: plan.isPopular,
              isBestValue: plan.isBestValue,
              discountText: plan.discountText,
              onTap: () => vm.selectPlan(plan),
              isUpgradeVariant: true,
            ),
          ),
        );
      }).toList(),
    );
  }

  // ═══ C. SECURITY BANNER ═══
  Widget _buildSecurityBanner(BuildContext context) {
    return PageEntranceAnimation(
      delay: const Duration(milliseconds: 100),
      child: Container(
        padding: EdgeInsets.all(context.scaleWidth(18)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: const Color(0xFF34d399).withValues(alpha: 0.05),
          border: Border.all(
            color: const Color(0xFF34d399).withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF34d399).withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                LucideIcons.shieldCheck,
                size: 20,
                color: Color(0xFF34d399),
              ),
            ),
            SizedBox(width: context.scaleWidth(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bank-Grade Security',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.scaleFontSize(14),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF34d399),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(2)),
                  Text(
                    'Your data is encrypted and handled securely.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.scaleFontSize(11),
                      color: const Color(0xFF34d399).withValues(alpha: 0.70),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══ D. COMPARISON TABLE ═══
  Widget _buildComparisonTable(BuildContext context) {
    return ComparisonTable(
      rows: [
        ComparisonRowData(
          feature: 'Feature',
          values: [
            ComparisonValue('Free'),
            ComparisonValue('Pro'),
            ComparisonValue('Annual'),
          ],
          isHeader: true,
        ),
        ComparisonRowData(
          feature: 'AI Summaries',
          icon: LucideIcons.sparkles,
          values: [
            ComparisonValue('10/day'),
            ComparisonValue('Unlimited'),
            ComparisonValue('Unlimited'),
          ],
        ),
        ComparisonRowData(
          feature: 'Fact Checks',
          icon: LucideIcons.shield,
          values: [
            ComparisonValue('5/day'),
            ComparisonValue('Unlimited'),
            ComparisonValue('Unlimited'),
          ],
        ),
        ComparisonRowData(
          feature: 'Vault Storage',
          icon: LucideIcons.infinity,
          values: [
            ComparisonValue('20 articles'),
            ComparisonValue('Unlimited'),
            ComparisonValue('Unlimited'),
          ],
        ),
        ComparisonRowData(
          feature: 'Offline Reading',
          icon: LucideIcons.bookOpen,
          values: [
            ComparisonValue('—'),
            ComparisonValue('✓'),
            ComparisonValue('✓'),
          ],
        ),
        ComparisonRowData(
          feature: 'Priority Support',
          icon: LucideIcons.headphones,
          values: [
            ComparisonValue('—'),
            ComparisonValue('—'),
            ComparisonValue('✓', highlight: true),
          ],
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getTestimonials() {
    return [
      {
        'name': 'Sarah M.',
        'quote':
            'The AI summaries alone saved me hours every week. Totally worth it.',
        'stars': 5,
      },
      {
        'name': 'James K.',
        'quote':
            'Annual plan is a no-brainer. The intelligence reports are incredible.',
        'stars': 5,
      },
      {
        'name': 'Aisha R.',
        'quote':
            'Best news app I\'ve ever used. Fact-checking gives me peace of mind.',
        'stars': 4,
      },
    ];
  }

  // ═══ F. FIXED BOTTOM CTA ═══
  Widget _buildFixedBottomCTA(BuildContext context, UpgradePlanViewModel vm) {
    final isSamePlan = vm.selectedPlan?.id == vm.currentPlan.id;
    return GradientCtaBackdrop(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SubPrimaryButton(
            label: isSamePlan
                ? 'Your Current Plan'
                : 'Upgrade to ${vm.selectedPlan?.name ?? 'Plan'}',
            iconRight: isSamePlan ? null : LucideIcons.arrowRight,
            enabled: vm.canContinue,
            onTap: vm.canContinue
                ? () =>
                      context.push('/profile/subscription/payment')
                : null,
          ),
          SizedBox(height: context.scaleHeight(12)),
          Text(
            'Secure checkout · Cancel anytime',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.scaleFontSize(11),
              color: AppColors.silverSecondaryLabel,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
