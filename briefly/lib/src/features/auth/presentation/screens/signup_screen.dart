import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../bloc/signup/signup_bloc.dart';
import '../../bloc/signup/signup_event.dart';
import '../../bloc/signup/signup_state.dart';
import '../widgets/app_text_input.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_footer_link.dart';
import '../widgets/auth_header.dart';
import '../widgets/country_dropdown.dart';
import '../widgets/gender_selector.dart';
import '../widgets/password_strength_indicator.dart';
import '../widgets/phone_input.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_auth_buttons.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SignupBloc(authRepository: context.read<AuthRepository>()),
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatelessWidget {
  const _SignupView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state.status == SignupStatus.success) {
            context.push(AppRouter.otp, extra: true);
          } else if (state.status == SignupStatus.cancelled) {
            // User cancelled - no action needed
          } else if (state.status == SignupStatus.error) {
            AppDialogs.showError(
              context,
              message: state.errorMessage ?? 'Sign up failed',
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.scaleHeight(16)),
                  const AuthBackButton(),
                  SizedBox(height: context.scaleHeight(16)),
                  const Center(
                    child: AuthHeader(
                      title: 'Create Account',
                      subtitle: 'Join Briefly',
                      icon: Icons.newspaper,
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(32)),
                  AppTextInput(
                    hintText: 'Full Name',
                    onChanged: (value) => context.read<SignupBloc>().add(
                      SignupFullNameChanged(value),
                    ),
                    errorText: state.fullNameError,
                  ),
                  SizedBox(height: context.scaleHeight(16)),
                  AppTextInput(
                    hintText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => context.read<SignupBloc>().add(
                      SignupEmailChanged(value),
                    ),
                    errorText: state.emailError,
                  ),
                  SizedBox(height: context.scaleHeight(16)),
                  PhoneInput(
                    onChanged: (phone) => context.read<SignupBloc>().add(
                      SignupPhoneChanged(phone),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(16)),
                  CountryDropdown(
                    selectedCountry: state.country,
                    onSelected: (value) => context.read<SignupBloc>().add(
                      SignupCountryChanged(value),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(24)),
                  GenderSelector(
                    selectedGender: state.gender,
                    onSelected: (value) => context.read<SignupBloc>().add(
                      SignupGenderChanged(value),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(24)),
                  AppTextInput(
                    hintText: 'Password',
                    obscureText: !state.isPasswordVisible,
                    showPasswordToggle: true,
                    onChanged: (value) => context.read<SignupBloc>().add(
                      SignupPasswordChanged(value),
                    ),
                    errorText: state.passwordError,
                  ),
                  if (state.password.isNotEmpty) ...[
                    SizedBox(height: context.scaleHeight(12)),
                    PasswordStrengthIndicator(strength: state.passwordStrength),
                  ],
                  SizedBox(height: context.scaleHeight(16)),
                  AppTextInput(
                    hintText: 'Confirm Password',
                    obscureText: !state.isPasswordVisible,
                    showPasswordToggle: true,
                    onChanged: (value) => context.read<SignupBloc>().add(
                      SignupConfirmPasswordChanged(value),
                    ),
                    errorText: state.confirmPasswordError,
                  ),
                  SizedBox(height: context.scaleHeight(32)),
                  PrimaryButton(
                    label: 'Create Account',
                    isLoading: state.status == SignupStatus.loading,
                    isDisabled: !state.isFormValid,
                    onPressed: () =>
                        context.read<SignupBloc>().add(const SignupSubmitted()),
                  ),
                  SizedBox(height: context.scaleHeight(32)),
                  const AuthDivider(text: 'Or sign up with'),
                  SizedBox(height: context.scaleHeight(24)),
                  SocialAuthButtons(
                    isSignUp: true,
                    onGoogleTap: () => context.read<SignupBloc>().add(
                      const SignupGoogleRequested(),
                    ),
                    onFacebookTap: () => context.read<SignupBloc>().add(
                      const SignupFacebookRequested(),
                    ),
                    onAppleTap: () => context.read<SignupBloc>().add(
                      const SignupAppleRequested(),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(24)),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaleWidth(16),
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            fontSize: context.scaleFontSize(11),
                            color: AppColors.silverSecondaryLabel,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(
                              text: 'By creating an account you agree to our ',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: AppColors.foreground,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: AppColors.foreground,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(32)),
                  AuthFooterLink(
                    caption: 'Already have an account?',
                    actionText: 'Sign In',
                    onTap: () => context.go(AppRouter.login),
                  ),
                  SizedBox(height: context.scaleHeight(40)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
