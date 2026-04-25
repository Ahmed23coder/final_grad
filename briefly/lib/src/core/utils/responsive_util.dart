import 'package:flutter/material.dart';

extension ResponsiveUtil on BuildContext {
  double scaleWidth(double value) {
    final scale = MediaQuery.sizeOf(this).width / 393;
    return value * scale.clamp(0.8, 1.4);
  }

  double scaleHeight(double value) {
    final scale = MediaQuery.sizeOf(this).height / 852;
    return value * scale.clamp(0.8, 1.4);
  }

  double scaleFontSize(double value) {
    final scale = MediaQuery.sizeOf(this).width / 393;
    return value * scale.clamp(0.85, 1.25);
  }

  double get screenWidth => MediaQuery.sizeOf(this).width;
}
