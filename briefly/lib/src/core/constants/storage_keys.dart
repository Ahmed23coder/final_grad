/// Centralised keys for SharedPreferences and FlutterSecureStorage.
///
/// Sensitive auth-flow values (OTP email/type) live in secure storage; UI
/// preferences (onboarding flag, interests) remain in SharedPreferences.
class StorageKeys {
  StorageKeys._();

  // Secure storage (FlutterSecureStorage)
  static const otpLastEmail = 'otp_last_email';
  static const otpLastType = 'otp_last_type';

  // SharedPreferences
  static const onboardingComplete = 'onboarding_complete';
  static const onboardingInterests = 'onboarding_interests';
}
