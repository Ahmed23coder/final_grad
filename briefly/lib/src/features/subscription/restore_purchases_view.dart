import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/mvvm/view_model_builder.dart';
import 'package:briefly/src/core/utils/app_animations.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';
import 'package:briefly/src/domain/repositories/profile_repository.dart';
import '../profile/cubits/subscription/restore_purchases_viewmodel.dart';
import 'widgets/standard_subscription_header.dart';
import 'widgets/subscription_widgets.dart';

class RestorePurchasesView extends StatelessWidget {
  const RestorePurchasesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestorePurchasesViewModel>.reactive(
      viewModelBuilder: () =>
          RestorePurchasesViewModel(context.read<ProfileRepository>()),
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                if (vm.state != RestoreState.restored)
                  const StandardSubscriptionHeader(
                    title: 'Restore Purchases',
                    subtitle: 'Recover your previous subscriptions',
                  ),
                Expanded(child: _buildBody(context, vm)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, RestorePurchasesViewModel vm) {
    switch (vm.state) {
      case RestoreState.idle:
        return _buildIdleState(context, vm);
      case RestoreState.scanning:
        return _buildScanningState(context);
      case RestoreState.found:
        return _buildFoundState(context, vm);
      case RestoreState.notFound:
        return _buildNotFoundState(context);
      case RestoreState.restored:
        return _buildRestoredState(context);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // IDLE STATE
  // ═══════════════════════════════════════════════════════════════
  Widget _buildIdleState(BuildContext context, RestorePurchasesViewModel vm) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(20)),
      child: Column(
        children: [
          // A. Info banner
          PageEntranceAnimation(
            delay: const Duration(milliseconds: 100),
            child: Container(
              padding: EdgeInsets.all(context.scaleWidth(18)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: const Color(0xFFf59e0b).withValues(alpha: 0.05),
                border: Border.all(
                  color: const Color(0xFFf59e0b).withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFf59e0b).withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      LucideIcons.shieldCheck,
                      size: 20,
                      color: Color(0xFFf59e0b),
                    ),
                  ),
                  SizedBox(width: context.scaleWidth(14)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Secure Restoration',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.scaleFontSize(14),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFf59e0b),
                          ),
                        ),
                        SizedBox(height: context.scaleHeight(2)),
                        Text(
                          'We\'ll scan your App Store account for previous purchases.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.scaleFontSize(11),
                            color: const Color(
                              0xFFf59e0b,
                            ).withValues(alpha: 0.70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // B. Empty state
          PageEntranceAnimation(
            delay: const Duration(milliseconds: 160),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: context.scaleHeight(32)),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.10),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      LucideIcons.refreshCcw,
                      size: 32,
                      color: AppColors.silverPlaceholder.withValues(
                        alpha: 0.40,
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(20)),
                  Text(
                    'Scan for Purchases',
                    style: TextStyle(
                      fontFamily: 'Newsreader',
                      fontSize: context.scaleFontSize(18),
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(8)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scaleWidth(20),
                    ),
                    child: Text(
                      'If you\'ve previously purchased a subscription, we can find and restore it to your account.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.scaleFontSize(12),
                        color: AppColors.silverPlaceholder.withValues(
                          alpha: 0.40,
                        ),
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(24)),
                  SubPrimaryButton(
                    label: 'Scan My Account',
                    iconLeft: LucideIcons.refreshCcw,
                    onTap: () => vm.startScan(),
                  ),
                ],
              ),
            ),
          ),

          // C. FAQ
          PageEntranceAnimation(
            delay: const Duration(milliseconds: 220),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SubSectionLabel('FREQUENTLY ASKED'),
                SizedBox(height: context.scaleHeight(12)),
                SubCard(
                  child: Column(
                    children: [
                      _faqRow(
                        context,
                        'When should I restore purchases?',
                        'Restore if you reinstalled the app, got a new device, or your subscription isn\'t showing.',
                      ),
                      Container(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      _faqRow(
                        context,
                        'Will I be charged again?',
                        'No. Restoring simply reactivates your existing subscription without any additional charges.',
                      ),
                      Container(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      _faqRow(
                        context,
                        'What if no purchases are found?',
                        'Make sure you\'re signed in with the same Apple ID or Google account used for the original purchase.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.scaleHeight(40)),
        ],
      ),
    );
  }

  Widget _faqRow(BuildContext context, String question, String answer) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleWidth(20),
        vertical: context.scaleHeight(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: context.scaleHeight(2)),
            child: Icon(
              LucideIcons.rotateCcw,
              size: 20,
              color: AppColors.silverPlaceholder,
            ),
          ),
          SizedBox(width: context.scaleWidth(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.scaleFontSize(15),
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: context.scaleHeight(4)),
                Text(
                  answer,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.scaleFontSize(12),
                    color: AppColors.silverSecondaryLabel,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SCANNING STATE
  // ═══════════════════════════════════════════════════════════════
  Widget _buildScanningState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(40)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.silverPlaceholder.withValues(alpha: 0.10),
                border: Border.all(
                  color: AppColors.silverPlaceholder.withValues(alpha: 0.20),
                ),
              ),
              alignment: Alignment.center,
              child: SpinningIcon(
                icon: LucideIcons.loader,
                size: 28,
                color: AppColors.silverPlaceholder,
                period: const Duration(milliseconds: 1500),
              ),
            ),
            SizedBox(height: context.scaleHeight(24)),
            Text(
              'Scanning Account...',
              style: TextStyle(
                fontFamily: 'Newsreader',
                fontSize: context.scaleFontSize(18),
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: context.scaleHeight(8)),
            Text(
              'Checking purchase history with the App Store',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.scaleFontSize(12),
                color: AppColors.silverPlaceholder.withValues(alpha: 0.40),
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
  // FOUND STATE
  // ═══════════════════════════════════════════════════════════════
  Widget _buildFoundState(BuildContext context, RestorePurchasesViewModel vm) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Found count
          PageEntranceAnimation(
            delay: const Duration(milliseconds: 100),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.circleCheck,
                  size: 14,
                  color: Color(0xFF4ade80),
                ),
                SizedBox(width: context.scaleWidth(8)),
                Text(
                  '${vm.foundPurchases.length} purchases found',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.scaleFontSize(14),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4ade80),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.scaleHeight(16)),
          // Purchase cards
          ...vm.foundPurchases.asMap().entries.map((entry) {
            final i = entry.key;
            final p = entry.value;
            final isSelected = vm.selectedPurchaseIndex == i;
            return RestorePurchaseCard(
              name: p.name,
              price: p.displayAmount,
              date: p.displayDate,
              platform: p.platform,
              txnId: p.txnId,
              isSelected: isSelected,
              onTap: () => vm.selectPurchase(i),
            );
          }),
          SizedBox(height: context.scaleHeight(24)),
          SubPrimaryButton(
            label: 'Restore Selected Purchase',
            iconLeft: LucideIcons.refreshCcw,
            enabled: vm.selectedPurchaseIndex != null,
            onTap: vm.selectedPurchaseIndex != null ? () => vm.restore() : null,
          ),
          SizedBox(height: context.scaleHeight(40)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // RESTORED STATE
  // ═══════════════════════════════════════════════════════════════
  Widget _buildNotFoundState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(40)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PageEntranceAnimation(
              delay: const Duration(milliseconds: 100),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF64748b).withValues(alpha: 0.10),
                  border: Border.all(
                    color: const Color(0xFF64748b).withValues(alpha: 0.20),
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  LucideIcons.circleX,
                  size: 40,
                  color: Color(0xFF64748b),
                ),
              ),
            ),
            SizedBox(height: context.scaleHeight(24)),
            PageEntranceAnimation(
              delay: const Duration(milliseconds: 200),
              child: Text(
                'No purchases found',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Newsreader',
                  fontSize: context.scaleFontSize(18),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: context.scaleHeight(12)),
            Text(
              'We could not find any historic purchases in your account.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.scaleFontSize(12),
                color: AppColors.silverPlaceholder.withValues(alpha: 0.50),
                height: 1.5,
              ),
            ),
            SizedBox(height: context.scaleHeight(24)),
            SubPrimaryButton(
              label: 'Back to Subscription',
              iconLeft: LucideIcons.arrowLeft,
              onTap: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestoredState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(40)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PageEntranceAnimation(
              delay: const Duration(milliseconds: 100),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4ade80).withValues(alpha: 0.10),
                  border: Border.all(
                    color: const Color(0xFF4ade80).withValues(alpha: 0.20),
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  LucideIcons.circleCheck,
                  size: 40,
                  color: Color(0xFF4ade80),
                ),
              ),
            ),
            SizedBox(height: context.scaleHeight(24)),
            PageEntranceAnimation(
              delay: const Duration(milliseconds: 200),
              child: Text(
                'Purchase Restored!',
                style: TextStyle(
                  fontFamily: 'Newsreader',
                  fontSize: context.scaleFontSize(22),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: context.scaleHeight(8)),
            PageEntranceAnimation(
              delay: const Duration(milliseconds: 260),
              child: Text(
                'Your Premium Monthly subscription has been successfully restored to your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.scaleFontSize(14),
                  color: AppColors.silverPlaceholder.withValues(alpha: 0.50),
                  height: 1.6,
                ),
              ),
            ),
            SizedBox(height: context.scaleHeight(32)),
            PageEntranceAnimation(
              delay: const Duration(milliseconds: 320),
              child: SubPrimaryButton(
                label: 'Back to Subscription',
                onTap: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
