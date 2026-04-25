import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/theme/app_radius.dart';
import 'package:briefly/src/core/utils/app_animations.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';
import '../../cubits/reset_password/profile_reset_password_cubit.dart';
import '../../cubits/reset_password/profile_reset_password_state.dart';

class ProfileResetPasswordScreen extends StatelessWidget {
  const ProfileResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileResetPasswordCubit(),
      child: const _ProfileResetPasswordView(),
    );
  }
}

class _ProfileResetPasswordView extends StatelessWidget {
  const _ProfileResetPasswordView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF102A43),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.only(
                    left: context.scaleWidth(20),
                    right: context.scaleWidth(20),
                    top: context.scaleHeight(14),
                    bottom: context.scaleHeight(8),
                  ),
                  child: Row(
                    children: [
                      _BackButton(),
                      SizedBox(width: context.scaleWidth(12)),
                      Text(
                        'Reset Password',
                        style: TextStyle(
                          fontFamily: 'Newsreader',
                          fontSize: context.scaleFontSize(24),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Lock Icon Hero
                        const _LockIconHero(),

                        // Description
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scaleWidth(40),
                          ),
                          child: Text(
                            "Enter your current password and choose a new one. Must be at least 6 characters.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.scaleFontSize(12),
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ),
                        SizedBox(height: context.scaleHeight(32)),

                        // Form
                        const PageEntranceAnimation(
                          delay: Duration(milliseconds: 150),
                          slideOffset: 20,
                          child: _ResetForm(),
                        ),
                        
                        SizedBox(height: context.scaleHeight(40)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Success Overlay
          const _SuccessOverlay(),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: () => context.pop(),
      child: Container(
        padding: EdgeInsets.all(context.scaleWidth(10)),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          shape: BoxShape.circle,
        ),
        child: Icon(
          LucideIcons.arrowLeft,
          size: context.scaleWidth(16),
          color: const Color(0xFFC0C0C0),
        ),
      ),
    );
  }
}

class _LockIconHero extends StatefulWidget {
  const _LockIconHero();

  @override
  State<_LockIconHero> createState() => _LockIconHeroState();
}

class _LockIconHeroState extends State<_LockIconHero> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.scaleHeight(32),
        bottom: context.scaleHeight(24),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacity.value,
            child: Transform.scale(
              scale: _scale.value,
              child: child,
            ),
          );
        },
        child: Container(
          width: context.scaleWidth(80),
          height: context.scaleWidth(80),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            borderRadius: BorderRadius.circular(50),
          ),
          alignment: Alignment.center,
          child: Icon(
            LucideIcons.lock,
            size: context.scaleWidth(32),
            color: const Color(0xFFC0C0C0).withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}

class _ResetForm extends StatelessWidget {
  const _ResetForm();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Label("Current Password"),
          const _PasswordField(
            type: _PasswordType.current,
            placeholder: "Enter current password",
          ),
          
          SizedBox(height: context.scaleHeight(24)),
          const _Divider(),
          SizedBox(height: context.scaleHeight(24)),

          const _Label("New Password"),
          const _PasswordField(
            type: _PasswordType.newPass,
            placeholder: "Enter new password",
          ),
          const _PasswordStrengthIndicator(),

          SizedBox(height: context.scaleHeight(16)),
          const _Label("Confirm New Password"),
          const _PasswordField(
            type: _PasswordType.confirm,
            placeholder: "Confirm new password",
          ),
          const _MatchErrorText(),

          SizedBox(height: context.scaleHeight(32)),
          const _SubmitButton(),
        ],
      ),
    );
  }
}

enum _PasswordType { current, newPass, confirm }

class _PasswordField extends StatelessWidget {
  final _PasswordType type;
  final String placeholder;

  const _PasswordField({
    required this.type,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileResetPasswordCubit, ProfileResetPasswordState>(
      builder: (context, state) {
        final cubit = context.read<ProfileResetPasswordCubit>();
        
        bool isVisible;
        VoidCallback toggle;
        ValueChanged<String> onChanged;
        bool hasError = false;

        switch (type) {
          case _PasswordType.current:
            isVisible = state.isCurrentVisible;
            toggle = cubit.toggleCurrentVisible;
            onChanged = cubit.updateCurrentPassword;
            break;
          case _PasswordType.newPass:
            isVisible = state.isNewVisible;
            toggle = cubit.toggleNewVisible;
            onChanged = cubit.updateNewPassword;
            break;
          case _PasswordType.confirm:
            isVisible = state.isConfirmVisible;
            toggle = cubit.toggleConfirmVisible;
            onChanged = cubit.updateConfirmPassword;
            hasError = state.isMatchError;
            break;
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            border: Border.all(
              color: hasError 
                  ? Colors.red.withValues(alpha: 0.4) 
                  : AppColors.borderColor,
            ),
            borderRadius: BorderRadius.circular(AppRadius.pillValue),
          ),
          child: TextField(
            obscureText: !isVisible,
            onChanged: onChanged,
            style: TextStyle(
              color: Colors.white,
              fontSize: context.scaleFontSize(14),
              fontFamily: 'Inter',
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.3),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: context.scaleHeight(14),
                horizontal: context.scaleWidth(24),
              ),
              border: InputBorder.none,
              suffixIcon: IconButton(
                onPressed: toggle,
                icon: Icon(
                  isVisible ? LucideIcons.eye : LucideIcons.eyeOff,
                  size: context.scaleWidth(18),
                  color: AppColors.mutedForeground.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.scaleWidth(8),
        bottom: context.scaleHeight(8),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: const Color(0xFFC0C0C0).withValues(alpha: 0.5),
          fontSize: context.scaleFontSize(10),
          letterSpacing: 1.5, // 0.15em
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.mutedForeground.withValues(alpha: 0.1),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(16)),
          child: Text(
            "NEW",
            style: TextStyle(
              color: AppColors.mutedForeground.withValues(alpha: 0.3),
              fontSize: context.scaleFontSize(9),
              letterSpacing: 2.0,
              fontFamily: 'Inter',
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.mutedForeground.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }
}

class _PasswordStrengthIndicator extends StatelessWidget {
  const _PasswordStrengthIndicator();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileResetPasswordCubit, ProfileResetPasswordState>(
      builder: (context, state) {
        if (state.newPassword.isEmpty) return const SizedBox.shrink();

        final strength = state.passwordStrength; // 1-4
        String label = "";
        Color color = Colors.transparent;

        switch (strength) {
          case 1:
            label = "Weak";
            color = Colors.red.shade400;
            break;
          case 2:
            label = "Fair";
            color = Colors.orange.shade400;
            break;
          case 3:
            label = "Good";
            color = Colors.yellow.shade400;
            break;
          case 4:
            label = "Strong";
            color = Colors.green.shade400;
            break;
        }

        return Column(
          children: [
            SizedBox(height: context.scaleHeight(8)),
            Row(
              children: List.generate(4, (index) {
                final active = index < strength;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == 3 ? 0 : context.scaleWidth(6),
                    ),
                    child: Container(
                      height: context.scaleHeight(4),
                      decoration: BoxDecoration(
                        color: active 
                            ? const Color(0xFFC0C0C0).withValues(alpha: 0.6) 
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(AppRadius.pillValue),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: context.scaleHeight(6)),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: context.scaleFontSize(10),
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MatchErrorText extends StatelessWidget {
  const _MatchErrorText();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileResetPasswordCubit, ProfileResetPasswordState>(
      builder: (context, state) {
        if (!state.isMatchError) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.only(
            top: context.scaleHeight(6),
            left: context.scaleWidth(8),
          ),
          child: Text(
            "Passwords don't match",
            style: TextStyle(
              color: Colors.red.shade400,
              fontSize: context.scaleFontSize(10),
              fontFamily: 'Inter',
            ),
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileResetPasswordCubit, ProfileResetPasswordState>(
      builder: (context, state) {
        final enabled = state.isValid;
        
        return PressScaleAnimation(
          onTap: enabled ? () => context.read<ProfileResetPasswordCubit>().submit() : null,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: context.scaleHeight(14)),
            decoration: BoxDecoration(
              color: enabled 
                  ? const Color(0xFFC0C0C0) 
                  : const Color(0xFFC0C0C0).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.pillValue),
            ),
            alignment: Alignment.center,
            child: state.isSaving
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.background,
                    ),
                  )
                : Text(
                    "Submit",
                    style: TextStyle(
                      color: enabled 
                          ? const Color(0xFF102A43) 
                          : const Color(0xFFC0C0C0).withValues(alpha: 0.3),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _SuccessOverlay extends StatefulWidget {
  const _SuccessOverlay();

  @override
  State<_SuccessOverlay> createState() => _SuccessOverlayState();
}

class _SuccessOverlayState extends State<_SuccessOverlay> with SingleTickerProviderStateMixin {
  bool _visible = false;
  late AnimationController _controller;
  late Animation<double> _iconScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _iconScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileResetPasswordCubit, ProfileResetPasswordState>(
      listenWhen: (prev, curr) => !prev.isSaved && curr.isSaved,
      listener: (context, state) {
        setState(() {
          _visible = true;
        });
        _controller.forward();
        
        Timer(const Duration(milliseconds: 2000), () {
          if (mounted) context.pop();
        });
      },
      child: _visible
          ? Container(
              color: AppColors.background,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _iconScale.value,
                        child: child,
                      );
                    },
                    child: Container(
                      width: context.scaleWidth(96),
                      height: context.scaleWidth(96),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.circleCheck,
                        size: context.scaleWidth(48),
                        color: Colors.green.shade400,
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(24)),
                  PageEntranceAnimation(
                    delay: const Duration(milliseconds: 300),
                    child: Text(
                      "Password Updated",
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
                    delay: const Duration(milliseconds: 500),
                    child: Text(
                      "Redirecting you back...",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.scaleFontSize(12),
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}



