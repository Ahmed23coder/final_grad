import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _supabase;
  final SharedPreferences _prefs;

  static const _kEmail = 'otp_last_email';
  static const _kOtpType = 'otp_last_type';

  static const _kEnvWebRedirect = String.fromEnvironment(
    'SUPABASE_REDIRECT_URL',
  );
  static const _kMobileRedirect = 'io.supabase.briefly://login-callback/';

  static String get _redirectTo {
    if (kIsWeb) {
      assert(
        _kEnvWebRedirect.isNotEmpty,
        'SUPABASE_REDIRECT_URL must be provided via --dart-define for web builds.',
      );
      return _kEnvWebRedirect;
    }
    return _kMobileRedirect;
  }

  SupabaseAuthRepository({
    required SharedPreferences prefs,
    SupabaseClient? supabase,
  }) : _prefs = prefs,
       _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<void> login({required String email, required String password}) async {
    await _prefs.setString(_kEmail, email);
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signup({
    required String fullName,
    required String email,
    required String phone,
    required String country,
    required String gender,
    required String password,
  }) async {
    await _prefs.setString(_kEmail, email);
    await _prefs.setString(_kOtpType, 'signup');
    await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone': phone,
        'country': country,
        'gender': gender,
      },
    );
  }

  /// Sends a password reset email containing a 6-digit OTP code.
  ///
  /// REQUIREMENT: The Supabase email template for "Reset Password"
  /// must include {{ .Token }} to display the 6-digit code.
  @override
  Future<void> sendPasswordResetCode({required String email}) async {
    await _prefs.setString(_kEmail, email);
    await _prefs.setString(_kOtpType, 'recovery');
    await _supabase.auth.resetPasswordForEmail(email);
  }

  @override
  Future<void> verifyOtp({required String code}) async {
    final email = _prefs.getString(_kEmail);
    final typeStr = _prefs.getString(_kOtpType);

    if (email == null || typeStr == null) {
      throw Exception('No email or OTP type associated with this session.');
    }

    final type = typeStr == 'signup' ? OtpType.signup : OtpType.recovery;

    await _supabase.auth.verifyOTP(type: type, token: code, email: email);

    await _prefs.remove(_kEmail);
    await _prefs.remove(_kOtpType);
  }

  @override
  Future<void> resendOtp() async {
    final email = _prefs.getString(_kEmail);
    final typeStr = _prefs.getString(_kOtpType);

    if (email == null || typeStr == null) {
      throw Exception('No email or OTP type associated with this session.');
    }

    final type = typeStr == 'signup' ? OtpType.signup : OtpType.recovery;

    await _supabase.auth.resend(type: type, email: email);
  }

  @override
  Future<void> saveInterests({required List<String> interests}) async {
    await _supabase.auth.updateUser(
      UserAttributes(data: {'interests': interests}),
    );
  }

  @override
  Future<void> signInWithGoogle() async {
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: _redirectTo,
    );
  }

  @override
  Future<void> signInWithFacebook() async {
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.facebook,
      redirectTo: _redirectTo,
    );
  }

  @override
  Future<void> signInWithApple() async {
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: _redirectTo,
    );
  }

  @override
  Future<void> resetPassword({required String newPassword}) async {
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }
}
