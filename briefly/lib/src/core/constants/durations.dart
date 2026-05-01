/// Centralised durations used across the app.
class AppDurations {
  AppDurations._();

  /// Cooldown between OTP resends.
  static const otpResendCooldown = Duration(seconds: 60);

  /// Default debounce for text fields.
  static const inputDebounce = Duration(milliseconds: 300);

  /// Simulated network delay used by mock subscription view-models.
  static const simulatedRequest = Duration(milliseconds: 1500);
}
