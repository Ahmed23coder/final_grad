import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:briefly/src/core/routes/app_router.dart';
import '../../cubits/privacy_security/privacy_security_cubit.dart';
import '../../cubits/privacy_security/privacy_security_state.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Use a single animation controller for memory efficiency
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF102A43),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  _SecurityStatusBanner(controller: _animationController),
                  const SizedBox(height: 32),
                  
                  _AnimatedSection(
                    controller: _animationController,
                    delay: 0.1,
                    child: const _SectionA(),
                  ),
                  const SizedBox(height: 24),
                  
                  _AnimatedSection(
                    controller: _animationController,
                    delay: 0.2,
                    child: const _SectionB(),
                  ),
                  const SizedBox(height: 24),
                  
                  _AnimatedSection(
                    controller: _animationController,
                    delay: 0.3,
                    child: const _SectionC(),
                  ),
                  const SizedBox(height: 24),
                  
                  _AnimatedSection(
                    controller: _animationController,
                    delay: 0.4,
                    child: const _SectionD(),
                  ),
                  const SizedBox(height: 40),
                ],
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
        top: MediaQuery.of(context).padding.top + 14, // pt-14 adjusted for safearea
        bottom: 20, // pb-5
        left: 20, // px-5
        right: 20,
      ),
      child: Row(
        children: [
          _InteractiveBackButton(),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Privacy & Security',
                style: TextStyle(
                  fontFamily: 'Newsreader',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2), // mt-0.5
              Text(
                'Manage your account security',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: const Color(0xFFC0C0C0).withValues(alpha: 0.4),
                ),
              ),
            ],
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
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: const Icon(LucideIcons.arrowLeft, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _SecurityStatusBanner extends StatelessWidget {
  final AnimationController controller;

  const _SecurityStatusBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    final opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    final dy = Tween<double>(begin: 8.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.translate(
            offset: Offset(0, dy.value),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16), // p-4
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF10B981).withValues(alpha: 0.1),
              const Color(0xFF14B8A6).withValues(alpha: 0.05),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(LucideIcons.shieldCheck, size: 18, color: Color(0xFF34D399)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Secured',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6EE7B7),
                    ),
                  ),
                  Text(
                    'Your account has no critical issues',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: const Color(0xFF34D399).withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.25)),
              ),
              child: Text(
                'Good',
                style: TextStyle(
                  fontSize: 10,
                  color: const Color(0xFF6EE7B7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _AnimatedSection extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final Widget child;

  const _AnimatedSection({
    required this.controller,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // End time is delay + 0.4, bounded by 1.0
    final end = (delay + 0.4).clamp(0.0, 1.0);
    
    final opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(delay, end, curve: Curves.easeOut),
      ),
    );

    final dy = Tween<double>(begin: 15.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(delay, end, curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.translate(
            offset: Offset(0, dy.value),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

// Reusables
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          letterSpacing: 1.5,
          color: const Color(0xFFC0C0C0).withValues(alpha: 0.5),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final List<Widget> children;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? dividerColor;

  const _CardContainer({
    required this.children,
    this.backgroundColor,
    this.borderColor,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    final borderCol = borderColor ?? Colors.white.withValues(alpha: 0.05);
    final divCol = dividerColor ?? Colors.white.withValues(alpha: 0.05);
    final bgCol = backgroundColor ?? Colors.white.withValues(alpha: 0.02);

    final dividedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      dividedChildren.add(children[i]);
      if (i < children.length - 1) {
        dividedChildren.add(Divider(height: 1, thickness: 1, color: divCol));
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: bgCol,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderCol),
      ),
      child: Column(
        children: dividedChildren,
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Widget rightWidget;
  final VoidCallback? onTap;
  final bool isDanger;

  const _RowItem({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.rightWidget,
    this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28), // Just for the ink effect bounds
      highlightColor: Colors.white.withValues(alpha: 0.03),
      splashColor: Colors.white.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDanger ? Colors.red.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                size: 16,
                color: isDanger ? Colors.red[400] : const Color(0xFFC0C0C0).withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: isDanger ? Colors.red[400] : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sublabel,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: const Color(0xFFC0C0C0).withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
            rightWidget,
          ],
        ),
      ),
    );
  }
}

class _CustomToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CustomToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack, // Built-in spring-like effect
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: value ? const Color(0xFFC0C0C0) : Colors.white.withValues(alpha: 0.12),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF102A43),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChevronRight extends StatelessWidget {
  final bool isDanger;
  const _ChevronRight({this.isDanger = false});

  @override
  Widget build(BuildContext context) {
    return Icon(
      LucideIcons.chevronRight,
      size: 16,
      color: isDanger ? Colors.red.withValues(alpha: 0.5) : const Color(0xFFC0C0C0).withValues(alpha: 0.3),
    );
  }
}

// SECTIONS

class _SectionA extends StatelessWidget {
  const _SectionA();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrivacySecurityCubit, PrivacySecurityState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Authentication'),
            _CardContainer(
              children: [
                _RowItem(
                  icon: LucideIcons.shieldCheck,
                  label: 'Two-Factor Authentication',
                  sublabel: state.twoFactorEnabled
                      ? 'Enabled via Authenticator App'
                      : 'Not enabled — tap to set up',
                  rightWidget: _CustomToggle(
                    value: state.twoFactorEnabled,
                    onChanged: (_) => context.read<PrivacySecurityCubit>().toggleTwoFactor(),
                  ),
                ),
                _RowItem(
                  icon: LucideIcons.bell,
                  label: 'Login Alerts',
                  sublabel: 'Get notified on new sign-ins',
                  rightWidget: _CustomToggle(
                    value: state.loginAlertsEnabled,
                    onChanged: (_) => context.read<PrivacySecurityCubit>().toggleLoginAlerts(),
                  ),
                ),
                _RowItem(
                  icon: LucideIcons.smartphone,
                  label: 'Face ID / Biometrics',
                  sublabel: 'Unlock app with biometrics',
                  rightWidget: _CustomToggle(
                    value: state.biometricsEnabled,
                    onChanged: (_) => context.read<PrivacySecurityCubit>().toggleBiometrics(),
                  ),
                ),
                _RowItem(
                  icon: LucideIcons.lock,
                  label: 'Change Password',
                  sublabel: 'Last changed 3 months ago',
                  rightWidget: const _ChevronRight(),
                  onTap: () => context.push(AppRouter.profileResetPassword),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SectionB extends StatelessWidget {
  const _SectionB();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrivacySecurityCubit, PrivacySecurityState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Privacy'),
            _CardContainer(
              children: [
                _RowItem(
                  icon: LucideIcons.eye,
                  label: 'Public Profile',
                  sublabel: 'Let others see your reading activity',
                  rightWidget: _CustomToggle(
                    value: state.publicProfileEnabled,
                    onChanged: (_) => context.read<PrivacySecurityCubit>().togglePublicProfile(),
                  ),
                ),
                _RowItem(
                  icon: LucideIcons.bellRing,
                  label: 'Activity Status',
                  sublabel: 'Show when you\'re online',
                  rightWidget: _CustomToggle(
                    value: state.activityStatusEnabled,
                    onChanged: (_) => context.read<PrivacySecurityCubit>().toggleActivityStatus(),
                  ),
                ),
                _RowItem(
                  icon: LucideIcons.eyeOff,
                  label: 'Read Receipts',
                  sublabel: 'Let senders know you\'ve read shared articles',
                  rightWidget: _CustomToggle(
                    value: state.readReceiptsEnabled,
                    onChanged: (_) => context.read<PrivacySecurityCubit>().toggleReadReceipts(),
                  ),
                ),
                _RowItem(
                  icon: LucideIcons.userX,
                  label: 'Blocked Accounts',
                  sublabel: '0 accounts blocked',
                  rightWidget: const _ChevronRight(),
                  onTap: () {},
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SectionC extends StatelessWidget {
  const _SectionC();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrivacySecurityCubit, PrivacySecurityState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Data & Personalisation'),
            _CardContainer(
              children: [
                _RowItem(
                  icon: LucideIcons.database,
                  label: 'Analytics & Data Collection',
                  sublabel: 'Help improve Rasseny with usage data',
                  rightWidget: _CustomToggle(
                    value: state.analyticsEnabled,
                    onChanged: (_) => context.read<PrivacySecurityCubit>().toggleAnalytics(),
                  ),
                ),
                _RowItem(
                  icon: LucideIcons.eye,
                  label: 'Personalised Ads',
                  sublabel: 'Use activity data for relevant ads',
                  rightWidget: _CustomToggle(
                    value: state.personalizedAdsEnabled,
                    onChanged: (_) => context.read<PrivacySecurityCubit>().togglePersonalizedAds(),
                  ),
                ),
                _RowItem(
                  icon: LucideIcons.download,
                  label: 'Download My Data',
                  sublabel: 'Request a copy of your data',
                  rightWidget: const _ChevronRight(),
                  onTap: () {},
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SectionD extends StatelessWidget {
  const _SectionD();

  void _showDeleteBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _DeleteConfirmationSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Danger Zone'),
        _CardContainer(
          backgroundColor: Colors.red.withValues(alpha: 0.05),
          borderColor: Colors.red.withValues(alpha: 0.2),
          dividerColor: Colors.red.withValues(alpha: 0.1),
          children: [
            _RowItem(
              icon: LucideIcons.triangleAlert,
              label: 'Deactivate Account',
              sublabel: 'Temporarily disable your account',
              isDanger: true,
              rightWidget: const _ChevronRight(isDanger: true),
              onTap: () {},
            ),
            _RowItem(
              icon: LucideIcons.trash2,
              label: 'Delete Account',
              sublabel: 'Permanently remove all your data',
              isDanger: true,
              rightWidget: const _ChevronRight(isDanger: true),
              onTap: () => _showDeleteBottomSheet(context),
            ),
          ],
        ),
      ],
    );
  }
}

class _DeleteConfirmationSheet extends StatelessWidget {
  const _DeleteConfirmationSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A3550),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(LucideIcons.trash2, size: 22, color: Colors.red[400]),
          ),
          const SizedBox(height: 16),
          const Text(
            'Delete Account?',
            style: TextStyle(
              fontFamily: 'Newsreader',
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This action is irreversible. All your data, saved articles, and preferences will be permanently removed. Are you sure you want to proceed?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: const Color(0xFFC0C0C0).withValues(alpha: 0.5),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                // Delete logic
                context.pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Delete Account',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.red[400],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => context.pop(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.06),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: const Color(0xFFC0C0C0).withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



