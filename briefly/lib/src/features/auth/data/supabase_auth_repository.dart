import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _supabase;
  // Kept for backwards-compatible callers (e.g. tests). New OTP-flow values
  // are stored via [_secureStorage] instead.
  // ignore: unused_field
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

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
    FlutterSecureStorage? secureStorage,
  }) : _prefs = prefs,
       _supabase = supabase ?? Supabase.instance.client,
       _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  Future<void> login({required String email, required String password}) async {
    await _writeOtpEmail(email);
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
    if (country.isEmpty) {
      throw ArgumentError.value(country, 'country', 'must not be empty');
    }
    await _writeOtpEmail(email);
    await _writeOtpType('signup');
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
    await _writeOtpEmail(email);
    await _writeOtpType('recovery');
    await _supabase.auth.resetPasswordForEmail(email);
  }

  @override
  Future<void> verifyOtp({required String code}) async {
    final email = await _secureStorage.read(key: StorageKeys.otpLastEmail);
    final typeStr = await _secureStorage.read(key: StorageKeys.otpLastType);

    if (email == null || typeStr == null) {
      throw Exception('No email or OTP type associated with this session.');
    }

    final type = typeStr == 'signup' ? OtpType.signup : OtpType.recovery;

    await _supabase.auth.verifyOTP(type: type, token: code, email: email);

    await _clearOtpState();
  }

  @override
  Future<void> resendOtp() async {
    final email = await _secureStorage.read(key: StorageKeys.otpLastEmail);
    final typeStr = await _secureStorage.read(key: StorageKeys.otpLastType);

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

  Future<void> _writeOtpEmail(String email) async {
    await _secureStorage.write(key: StorageKeys.otpLastEmail, value: email);
  }

  Future<void> _writeOtpType(String type) async {
    await _secureStorage.write(key: StorageKeys.otpLastType, value: type);
  }

  Future<void> _clearOtpState() async {
    await _secureStorage.delete(key: StorageKeys.otpLastEmail);
    await _secureStorage.delete(key: StorageKeys.otpLastType);
  }
}
