import 'package:flutter/material.dart';

/// Briefly Design System — Radius Tokens
class AppRadius {
  AppRadius._();

  static const double buttonValue = 1.185;
  static const double pillValue = 50.0;
  static const double cardValue = 24.0;
  static const double settingsGroupValue = 28.0;

  static final BorderRadius button = BorderRadius.circular(pillValue);
  static final BorderRadius card = BorderRadius.circular(cardValue);
  static final BorderRadius settingsGroup = BorderRadius.circular(settingsGroupValue);
  static final BorderRadius circular = BorderRadius.circular(9999.0);
}
