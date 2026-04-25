import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/exceptions/auth_exceptions.dart';

/// Translates auth-layer exceptions into short, user-facing copy.
///
/// Always logs the raw error via `dart:developer.log` under the `auth` name so
/// the original message is still available for debugging without leaking
/// stack-trace flavoured strings into the UI.
class AuthErrorMapper {
  static const _genericMessage = 'Something went wrong, please try again.';

  static String toUserMessage(Object error, {StackTrace? stackTrace}) {
    developer.log(
      'Auth error: $error',
      name: 'auth',
      error: error,
      stackTrace: stackTrace,
    );

    if (error is AuthCanceledException) {
      return 'Sign-in was cancelled.';
    }

    if (error is AuthException) {
      return _mapAuthException(error);
    }

    if (error is AuthRetryableFetchException) {
      return 'Network error. Check your connection and try again.';
    }

    if (error is PostgrestException) {
      return 'We could not save your data. Please try again.';
    }

    return _genericMessage;
  }

  static String _mapAuthException(AuthException e) {
    final message = e.message.toLowerCase();
    if (message.contains('invalid login credentials') ||
        message.contains('invalid_credentials')) {
      return 'Email or password is incorrect.';
    }
    if (message.contains('email not confirmed')) {
      return 'Please verify your email before signing in.';
    }
    if (message.contains('user already registered') ||
        message.contains('already registered')) {
      return 'This email is already registered. Try signing in instead.';
    }
    if (message.contains('rate limit') || message.contains('too many')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }
    if (message.contains('token has expired') ||
        message.contains('otp expired') ||
        message.contains('invalid otp')) {
      return 'The verification code is invalid or has expired.';
    }
    if (message.contains('weak password') || message.contains('password should')) {
      return 'Password is too weak. Please choose a stronger one.';
    }
    if (message.contains('network')) {
      return 'Network error. Check your connection and try again.';
    }
    return _genericMessage;
  }
}
