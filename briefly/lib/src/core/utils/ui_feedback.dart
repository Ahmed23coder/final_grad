import 'package:flutter/material.dart';

/// Small helpers for one-line UI feedback used across screens whose backend
/// actions are not yet wired up. Keeps the buttons interactive and gives the
/// user confirmation that a tap was registered, instead of silent no-ops.
class UiFeedback {
  UiFeedback._();

  /// Show a transient snackbar with a neutral confirmation message.
  static void showSnack(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show a "coming soon" snackbar for actions whose backend isn't ready yet.
  static void showComingSoon(BuildContext context, [String? feature]) {
    final label = feature == null ? 'This feature' : '"$feature"';
    showSnack(context, '$label is coming soon.');
  }

  /// Show a confirmation dialog with destructive styling. Returns true if the
  /// user confirmed.
  static Future<bool> confirmDestructive(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
