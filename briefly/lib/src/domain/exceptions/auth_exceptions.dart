class AuthCanceledException implements Exception {
  final String message;
  const AuthCanceledException([this.message = 'Authentication was cancelled by user']);

  @override
  String toString() => message;
}