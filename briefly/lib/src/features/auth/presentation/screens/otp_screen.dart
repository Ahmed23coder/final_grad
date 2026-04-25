import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../bloc/otp/otp_bloc.dart';
import '../../bloc/otp/otp_event.dart';
import '../../bloc/otp/otp_state.dart';
import '../widgets/auth_icon_header.dart';
import '../widgets/otp_input_field.dart';
import '../widgets/primary_button.dart';

class OtpScreen extends StatelessWidget {
  final bool isFromSignup;

  const OtpScreen({super.key, this.isFromSignup = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OtpBloc(authRepository: context.read<AuthRepository>()),
      child: _OtpView(isFromSignup: isFromSignup),
    );
  }
}

class _OtpView extends StatelessWidget {
  final bool isFromSignup;

  const _OtpView({required this.isFromSignup});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<OtpBloc, OtpState>(
        listener: (context, state) {
          if (state.status == OtpStatus.success) {
            if (isFromSignup) {
              context.go(AppRouter.interests);
            } else {
              context.go(AppRouter.resetPassword);
            }
          } else if (state.status == OtpStatus.error) {
            AppDialogs.showError(
              context,
              message: state.errorMessage ?? 'Invalid code',
            );
          } else if (state.status == OtpStatus.resendSuccess) {
            AppDialogs.showSuccess(
              context,
              message: 'A new code has been sent to your email.',
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
                    icon: Icons.verified_user_outlined,
                    title: 'Check your email',
                    description:
                        "We've sent a 6-digit verification code to your email address.",
                  ),
                  SizedBox(height: context.scaleHeight(48)),
                  OtpInputField(
                    onCompleted: (code) =>
                        context.read<OtpBloc>().add(OtpCodeChanged(code)),
                    hasError: state.status == OtpStatus.error,
                  ),
                  if (state.status == OtpStatus.error) ...[
                    SizedBox(height: context.scaleHeight(12)),
                    Text(
                      state.errorMessage ?? 'Invalid verification code',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.scaleFontSize(12),
                        fontWeight: FontWeight.w400,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                  SizedBox(height: context.scaleHeight(32)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Resend code in ',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.scaleFontSize(14),
                          color: AppColors.silverSecondaryLabel,
                        ),
                      ),
                      Text(
                        state.formattedTime,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.scaleFontSize(14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                    ],
                  ),
                  if (state.canResend ||
                      state.status == OtpStatus.resendLoading) ...[
                    TextButton(
                      onPressed: state.status == OtpStatus.resendLoading
                          ? null
                          : () => context.read<OtpBloc>().add(
                              const OtpResendRequested(),
                            ),
                      child: state.status == OtpStatus.resendLoading
                          ? SizedBox(
                              width: context.scaleWidth(16),
                              height: context.scaleWidth(16),
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.accentBlue,
                                ),
                              ),
                            )
                          : const Text(
                              'Resend Now',
                              style: TextStyle(color: AppColors.accentBlue),
                            ),
                    ),
                  ],
                  SizedBox(height: context.scaleHeight(32)),
                  PrimaryButton(
                    label: 'Verify',
                    isLoading: state.status == OtpStatus.loading,
                    isDisabled: !state.isComplete,
                    onPressed: () =>
                        context.read<OtpBloc>().add(const OtpVerifySubmitted()),
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
