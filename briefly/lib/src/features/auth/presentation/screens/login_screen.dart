import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../bloc/login/login_bloc.dart';
import '../../bloc/login/login_event.dart';
import '../../bloc/login/login_state.dart';
import '../widgets/app_text_input.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_footer_link.dart';
import '../widgets/auth_header.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_auth_buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginBloc(authRepository: context.read<AuthRepository>()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            context.go(AppRouter.shell);
          } else if (state.status == LoginStatus.cancelled) {
            // User cancelled - no action needed, just reset to initial
          } else if (state.status == LoginStatus.error) {
            AppDialogs.showError(
              context,
              message: state.errorMessage ?? 'Login failed',
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.pagePadding(context),
              child: Column(
                children: [
                  SizedBox(height: context.scaleHeight(40)),
                  const AuthHeader(
                    title: 'Welcome Back',
                    subtitle: 'Sign in to continue',
                    icon: Icons.newspaper,
                  ),
                  SizedBox(height: context.scaleHeight(40)),
                  AppTextInput(
                    hintText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) =>
                        context.read<LoginBloc>().add(LoginEmailChanged(value)),
                    errorText: state.emailError,
                  ),
                  SizedBox(height: context.scaleHeight(16)),
                  AppTextInput(
                    hintText: 'Password',
                    obscureText: !state.isPasswordVisible,
                    showPasswordToggle: true,
                    onChanged: (value) => context.read<LoginBloc>().add(
                      LoginPasswordChanged(value),
                    ),
                    errorText: state.passwordError,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(AppRouter.forgotPassword),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.scaleFontSize(12),
                          color: AppColors.silverPlaceholder,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(12)),
                  PrimaryButton(
                    label: 'Sign In',
                    isLoading: state.status == LoginStatus.loading,
                    isDisabled: !state.isFormValid,
                    onPressed: () =>
                        context.read<LoginBloc>().add(const LoginSubmitted()),
                  ),
                  SizedBox(height: context.scaleHeight(32)),
                  const AuthDivider(text: 'Or sign in with'),
                  SizedBox(height: context.scaleHeight(24)),
                  SocialAuthButtons(
                    onGoogleTap: () => context.read<LoginBloc>().add(
                      const LoginGoogleRequested(),
                    ),
                    onFacebookTap: () => context.read<LoginBloc>().add(
                      const LoginFacebookRequested(),
                    ),
                    onAppleTap: () => context.read<LoginBloc>().add(
                      const LoginAppleRequested(),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(32)),
                  AuthFooterLink(
                    caption: "Don't have an account?",
                    actionText: 'Sign Up',
                    onTap: () => context.push(AppRouter.signup),
                  ),
                  SizedBox(height: context.scaleHeight(24)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
