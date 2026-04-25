import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../bloc/reset_password/reset_password_bloc.dart';
import '../../bloc/reset_password/reset_password_event.dart';
import '../../bloc/reset_password/reset_password_state.dart';
import '../widgets/app_text_input.dart';
import '../widgets/auth_icon_header.dart';
import '../widgets/password_strength_indicator.dart';
import '../widgets/primary_button.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ResetPasswordBloc(authRepository: context.read<AuthRepository>()),
      child: const _ResetPasswordView(),
    );
  }
}

class _ResetPasswordView extends StatelessWidget {
  const _ResetPasswordView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          if (state.status == ResetPasswordStatus.success) {
            context.go(AppRouter.authSuccess);
          } else if (state.status == ResetPasswordStatus.error) {
            AppDialogs.showError(
              context,
              message: state.errorMessage ?? 'Failed to reset password',
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(24)),
              child: Column(
                children: [
                  SizedBox(height: context.scaleHeight(16)),
                  const AuthIconHeader(
                    icon: Icons.lock_outline,
                    title: 'Reset Password',
                    description:
                        'Enter your new password below to regain access to your account.',
                  ),
                  SizedBox(height: context.scaleHeight(40)),
                  AppTextInput(
                    labelText: 'New Password',
                    hintText: '••••••••',
                    obscureText: true,
                    showPasswordToggle: true,
                    onChanged: (v) => context.read<ResetPasswordBloc>().add(
                      ResetPasswordNewPasswordChanged(v),
                    ),
                    errorText: state.passwordError,
                  ),
                  SizedBox(height: context.scaleHeight(16)),
                  PasswordStrengthIndicator(strength: state.strength),
                  SizedBox(height: context.scaleHeight(24)),
                  AppTextInput(
                    labelText: 'Confirm Password',
                    hintText: '••••••••',
                    obscureText: true,
                    showPasswordToggle: true,
                    onChanged: (v) => context.read<ResetPasswordBloc>().add(
                      ResetPasswordConfirmChanged(v),
                    ),
                    errorText: state.confirmError,
                  ),
                  SizedBox(height: context.scaleHeight(32)),
                  PrimaryButton(
                    label: 'Reset Password',
                    isLoading: state.status == ResetPasswordStatus.loading,
                    isDisabled: !state.isFormValid,
                    onPressed: () => context.read<ResetPasswordBloc>().add(
                      const ResetPasswordSubmitted(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
