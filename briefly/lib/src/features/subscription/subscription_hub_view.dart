import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/routes/app_router.dart';
import 'package:briefly/src/core/mvvm/view_model_builder.dart';
import 'package:briefly/src/core/utils/app_animations.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';
import 'package:briefly/src/domain/repositories/profile_repository.dart';
import '../profile/cubits/subscription/subscription_hub_viewmodel.dart';
import 'widgets/standard_subscription_header.dart';
import 'widgets/subscription_widgets.dart';

class SubscriptionHubView extends StatelessWidget {
  const SubscriptionHubView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SubscriptionHubViewModel>.reactive(
      viewModelBuilder: () =>
          SubscriptionHubViewModel(context.read<ProfileRepository>()),
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
                      const StandardSubscriptionHeader(title: 'Subscription'),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scaleWidth(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildCurrentPlanBadge(context, vm),
                              SizedBox(height: context.scaleHeight(16)),
                              _buildPlanCards(context, vm),
                              SizedBox(height: context.scaleHeight(24)),
                              _buildActionButtons(context, vm),
                              SizedBox(height: context.scaleHeight(24)),
                              _buildTodayUsage(context),
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

  // ─── A. CURRENT PLAN BADGE ───────────────────────────────────────────────
  Widget _buildCurrentPlanBadge(
    BuildContext context,
    SubscriptionHubViewModel vm,
  ) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.scaleWidth(24),
          vertical: context.scaleHeight(12),
        ),
        decoration: BoxDecoration(
          color: AppColors.silverPlaceholder.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: AppColors.silverPlaceholder.withValues(alpha: 0.20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.crown,
              color: AppColors.silverPlaceholder,
              size: context.scaleWidth(16),
            ),
            SizedBox(width: context.scaleWidth(8)),
            Text(
              'Current Plan: ${vm.currentPlan.name}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.scaleFontSize(14),
                fontWeight: FontWeight.w500,
                color: AppColors.silverPlaceholder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── B. PLAN CARDS ────────────────────────────────────────────────────────
  Widget _buildPlanCards(BuildContext context, SubscriptionHubViewModel vm) {
    return Column(
      children: vm.plans.asMap().entries.map((entry) {
        final i = entry.key;
        final plan = entry.value;
        final isSelected = vm.selectedPlan?.id == plan.id;

        return PageEntranceAnimation(
          delay: Duration(milliseconds: 100 + i * 60),
          child: Padding(
            padding: EdgeInsets.only(bottom: context.scaleHeight(16)),
            child: PlanSelectionCard(
              name: plan.name,
              price: plan.displayPrice,
              interval: plan.interval,
              planColor: plan.color,
              icon: plan.icon,
              features: plan.features,
              isSelected: isSelected,
              isPopular: plan.isPopular,
              isBestValue: plan.isBestValue,
              discountText: plan.discountText,
              onTap: () => vm.selectPlan(plan),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Redundant badge methods removed - handled by BadgePill

  // ─── C. ACTION BUTTONS ───────────────────────────────────────────────────
  Widget _buildActionButtons(
    BuildContext context,
    SubscriptionHubViewModel vm,
  ) {
    final isSelectedActive = vm.selectedPlan?.id == vm.currentPlan.id;
    return PageEntranceAnimation(
      delay: const Duration(milliseconds: 280),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SubPrimaryButton(
            label: isSelectedActive ? 'Manage Subscription' : 'Upgrade Plan',
            onTap: () {
              if (isSelectedActive) {
                context.push(AppRouter.subscriptionManage);
              } else {
                context.push(AppRouter.subscriptionUpgrade);
              }
            },
          ),
          SizedBox(height: context.scaleHeight(12)),
          SubSecondaryButton(
            label: 'Restore Purchases',
            onTap: () => context.push(AppRouter.restore),
          ),
        ],
      ),
    );
  }

  // ─── D. TODAY'S USAGE ─────────────────────────────────────────────────────
  Widget _buildTodayUsage(BuildContext context) {
    return PageEntranceAnimation(
      delay: const Duration(milliseconds: 340),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SubSectionLabel("TODAY'S USAGE"),
          SizedBox(height: context.scaleHeight(12)),
          SubCard(
            padding: EdgeInsets.all(context.scaleWidth(20)),
            child: Column(
              children: [
                _buildUsageRow(
                  context,
                  LucideIcons.sparkles,
                  'AI Summaries',
                  '12 / ∞',
                ),
                SizedBox(height: context.scaleHeight(16)),
                _buildUsageRow(
                  context,
                  LucideIcons.shield,
                  'Fact Checks',
                  '5 / ∞',
                ),
                SizedBox(height: context.scaleHeight(16)),
                _buildUsageRow(
                  context,
                  LucideIcons.infinity,
                  'Vault Storage',
                  '38 / ∞',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: context.scaleWidth(14),
          color: AppColors.silverPlaceholder.withValues(alpha: 0.50),
        ),
        SizedBox(width: context.scaleWidth(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.scaleFontSize(12),
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.scaleFontSize(10),
                      color: AppColors.silverPlaceholder.withValues(
                        alpha: 0.50,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.scaleHeight(6)),
              Container(
                height: context.scaleHeight(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.silverPlaceholder.withValues(
                        alpha: 0.40,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
