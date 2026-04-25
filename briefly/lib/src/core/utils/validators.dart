class Validators {
  Validators._();

  // Wider email regex: allows + in local part, longer TLDs, hyphens.
  static final _emailRegex = RegExp(
    r"^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$",
  );

  static final _upperRegex = RegExp(r'[A-Z]');
  static final _digitRegex = RegExp(r'[0-9]');
  static final _specialRegex = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');

  // Loose phone regex: optional leading +, then 7-15 digits (E.164).
  static final _phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');

  static String? validateEmail(String email) {
    if (email.isEmpty) return null;
    if (!_emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return null;
    if (password.length < 8) return 'Password must be at least 8 characters';
    if (!_upperRegex.hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!_digitRegex.hasMatch(password)) {
      return 'Password must contain at least one number';
    }
    if (!_specialRegex.hasMatch(password)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  static String? validateName(String name) {
    if (name.isEmpty) return null;
    if (name.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  static String? validateConfirmPassword(String password, String confirm) {
    if (confirm.isEmpty) return null;
    if (confirm != password) return 'Passwords do not match';
    return null;
  }

  static String? validatePhone(String phone) {
    if (phone.isEmpty) return null;
    final stripped = phone.replaceAll(RegExp(r'\s'), '');
    if (!_phoneRegex.hasMatch(stripped)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Returns 0=weak, 1=fair, 2=good, 3=strong
  static int calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;
    int score = 0;
    if (password.length >= 8) score++;
    if (_upperRegex.hasMatch(password)) score++;
    if (_digitRegex.hasMatch(password)) score++;
    if (_specialRegex.hasMatch(password)) score++;

    if (score >= 4) return 3;
    if (score >= 3) return 2;
    if (score >= 2) return 1;
    return 0;
  }

  static String getPasswordRequirementsText() {
    return 'Password must be at least 8 characters with uppercase, number, and special character';
  }
}
