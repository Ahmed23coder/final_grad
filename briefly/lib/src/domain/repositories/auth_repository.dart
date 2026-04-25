/// Abstract auth repository contract.
/// Implementations live in the data layer (e.g., MockAuthRepository).
abstract class AuthRepository {
  Future<void> login({required String email, required String password});

  Future<void> signup({
    required String fullName,
    required String email,
    required String phone,
    required String country,
    required String gender,
    required String password,
  });

  Future<void> sendPasswordResetCode({required String email});

  Future<void> verifyOtp({required String code});

  Future<void> resendOtp();

  Future<void> saveInterests({required List<String> interests});

  Future<void> signInWithGoogle();
  Future<void> signInWithFacebook();
  Future<void> signInWithApple();

  Future<void> resetPassword({required String newPassword});
}
