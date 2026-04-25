import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../profile/cubits/subscription/subscription_cubit.dart';
import '../profile/cubits/subscription/subscription_state.dart';
import '../../domain/models/plan_type.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF102A43),
      body: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
                builder: (context, state) {
                  return ListView(
                    padding: const EdgeInsets.only(bottom: 32),
                    children: [
                      const _CurrentPlanBadge(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _PlanCard(
                              type: PlanType.free,
                              title: 'Free',
                              icon: LucideIcons.zap,
                              price: '\$0',
                              period: ' / month',
                              features: const [
                                '10 AI Summaries/day',
                                '5 Fact Checks/day',
                                'Basic Search',
                                'Limited Vault (20)',
                              ],
                              selectedPlan: state.selectedPlan,
                              activePlan: state.activePlan,
                              onTap: () => context
                                  .read<SubscriptionCubit>()
                                  .selectPlan(PlanType.free),
                            ),
                            const SizedBox(height: 16),
                            _PlanCard(
                              type: PlanType.premium,
                              title: 'Premium',
                              icon: LucideIcons.crown,
                              price: '\$9.99',
                              period: ' / month',
                              isPopular: true,
                              features: const [
                                'Unlimited AI Summaries',
                                'Unlimited Fact Checks',
                                'Advanced Search',
                                'Unlimited Vault',
                                'Priority Breaking News',
                                'Ad-Free',
                                'Offline Reading',
                              ],
                              selectedPlan: state.selectedPlan,
                              activePlan: state.activePlan,
                              onTap: () => context
                                  .read<SubscriptionCubit>()
                                  .selectPlan(PlanType.premium),
                            ),
                            const SizedBox(height: 16),
                            _PlanCard(
                              type: PlanType.annual,
                              title: 'Annual Premium',
                              icon: LucideIcons.sparkles,
                              price: '\$79.99',
                              period: ' / year',
                              saveLabel: 'Save 33%',
                              features: const [
                                'Everything in Premium',
                                'Exclusive Intelligence Reports',
                                'Early Access',
                                'Priority Support',
                              ],
                              selectedPlan: state.selectedPlan,
                              activePlan: state.activePlan,
                              onTap: () => context
                                  .read<SubscriptionCubit>()
                                  .selectPlan(PlanType.annual),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _ActionButtons(state: state),
                      const SizedBox(height: 32),
                      const _UsageStats(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      child: Row(
        children: [
          _InteractiveBackButton(),
          const SizedBox(width: 16),
          const Text(
            'Subscription',
            style: TextStyle(
              fontFamily: 'Newsreader',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractiveBackButton extends StatefulWidget {
  @override
  State<_InteractiveBackButton> createState() => _InteractiveBackButtonState();
}

class _InteractiveBackButtonState extends State<_InteractiveBackButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        context.pop();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Transform.scale(
        scale: _isPressed ? 0.95 : 1.0,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: const Icon(
            LucideIcons.arrowLeft,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _CurrentPlanBadge extends StatelessWidget {
  const _CurrentPlanBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFC0C0C0).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: const Color(0xFFC0C0C0).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(LucideIcons.crown, size: 16, color: Color(0xFFC0C0C0)),
          SizedBox(width: 8),
          Text(
            'Current Plan: Premium',
            style: TextStyle(
              fontFamily: 'Inter',
              color: Color(0xFFC0C0C0),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final PlanType type;
  final String title;
  final IconData icon;
  final String price;
  final String period;
  final List<String> features;
  final bool isPopular;
  final String? saveLabel;
  final PlanType selectedPlan;
  final PlanType activePlan;
  final VoidCallback onTap;

  const _PlanCard({
    required this.type,
    required this.title,
    required this.icon,
    required this.price,
    required this.period,
    required this.features,
    this.isPopular = false,
    this.saveLabel,
    required this.selectedPlan,
    required this.activePlan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedPlan == type;
    final isActiveEnum = activePlan == type;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFC0C0C0).withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFC0C0C0).withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFC0C0C0).withValues(alpha: 0.15)
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        icon,
                        size: 18,
                        color: isSelected
                            ? const Color(0xFFC0C0C0)
                            : const Color(0xFFC0C0C0).withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (isPopular) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC0C0C0),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Text(
                                  'POPULAR',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.0,
                                    color: Color(0xFF102A43),
                                  ),
                                ),
                              ),
                            ],
                            if (isActiveEnum) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF4ADE80,
                                  ).withValues(alpha: 0.1),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF4ADE80,
                                    ).withValues(alpha: 0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Text(
                                  'Active',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF4ADE80),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              price,
                              style: const TextStyle(
                                fontFamily: 'Newsreader',
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              period,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: const Color(
                                  0xFFC0C0C0,
                                ).withValues(alpha: 0.6),
                              ),
                            ),
                            if (saveLabel != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                saveLabel!,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  color: Color(0xFF4ADE80),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? const Color(0xFFC0C0C0)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFC0C0C0)
                          : Colors.white.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Center(
                          child: Icon(
                            LucideIcons.check,
                            size: 12,
                            color: Color(0xFF102A43),
                          ),
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 52),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: features.map((feat) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.check,
                          size: 12,
                          color: isSelected
                              ? const Color(0xFFC0C0C0)
                              : const Color(0xFFC0C0C0).withValues(alpha: 0.3),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          feat,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: const Color(
                              0xFFC0C0C0,
                            ).withValues(alpha: 0.6),
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
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final SubscriptionState state;
  const _ActionButtons({required this.state});

  @override
  Widget build(BuildContext context) {
    final String mainLabel = (state.selectedPlan == state.activePlan)
        ? 'Manage Subscription'
        : 'Upgrade Plan';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFC0C0C0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                mainLabel,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: Color(0xFF102A43),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {},
            child: Text(
              'Restore Purchases',
              style: TextStyle(
                fontFamily: 'Inter',
                color: const Color(0xFFC0C0C0).withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UsageStats extends StatelessWidget {
  const _UsageStats();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'USAGE STATS',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                letterSpacing: 2.0,
                color: const Color(0xFFC0C0C0).withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              children: const [
                _UsageRow(
                  icon: LucideIcons.sparkles,
                  label: 'AI Summaries',
                  used: '12',
                  total: 'âˆž',
                ),
                SizedBox(height: 16),
                _UsageRow(
                  icon: LucideIcons.shield,
                  label: 'Fact Checks',
                  used: '5',
                  total: 'âˆž',
                ),
                SizedBox(height: 16),
                _UsageRow(
                  icon: LucideIcons.infinity,
                  label: 'Vault Storage',
                  used: '38',
                  total: 'âˆž',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UsageRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String used;
  final String total;

  const _UsageRow({
    required this.icon,
    required this.label,
    required this.used,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: const Color(0xFFC0C0C0).withValues(alpha: 0.5),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(
              '$used / $total',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: const Color(0xFFC0C0C0).withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(50),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor:
                1.0, // Because they are all infinite limits in Premium plan design
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFC0C0C0).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
