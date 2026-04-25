import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../bloc/forgot_password/forgot_password_bloc.dart';
import '../../bloc/forgot_password/forgot_password_event.dart';
import '../../bloc/forgot_password/forgot_password_state.dart';
import '../widgets/app_text_input.dart';
import '../widgets/auth_footer_link.dart';
import '../widgets/auth_icon_header.dart';
import '../widgets/primary_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ForgotPasswordBloc(authRepository: context.read<AuthRepository>()),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatelessWidget {
  const _ForgotPasswordView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.success) {
            context.push(AppRouter.otp, extra: false);
          } else if (state.status == ForgotPasswordStatus.error) {
            AppDialogs.showError(
              context,
              message: state.errorMessage ?? 'Error occurred',
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
                    icon: Icons.email_outlined,
                    title: 'Forgot Password',
                    description:
                        "Enter your email address and we'll send you a recovery link.",
                  ),
                  SizedBox(height: context.scaleHeight(40)),
                  AppTextInput(
                    hintText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => context
                        .read<ForgotPasswordBloc>()
                        .add(ForgotPasswordEmailChanged(value)),
                    errorText: state.emailError,
                  ),
                  SizedBox(height: context.scaleHeight(32)),
                  PrimaryButton(
                    label: 'Send Code',
                    isLoading: state.status == ForgotPasswordStatus.loading,
                    isDisabled: !state.isFormValid,
                    onPressed: () => context.read<ForgotPasswordBloc>().add(
                      const ForgotPasswordSubmitted(),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(40)),
                  AuthFooterLink(
                    caption: 'Remember your password?',
                    actionText: 'Login',
                    onTap: () => context.go(AppRouter.login),
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
