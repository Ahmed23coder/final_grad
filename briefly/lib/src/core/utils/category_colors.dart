import 'package:flutter/material.dart';

/// Maps news categories to a consistent accent color used for badges/chips.
/// Falls back to the default accent blue for unknown categories.
class CategoryColors {
  CategoryColors._();

  static const _defaultColor = Color(0xFF3B82F6); // accent blue

  static const _map = <String, Color>{
    'world': Color(0xFF3B82F6),       // blue
    'business': Color(0xFFF59E0B),    // amber
    'technology': Color(0xFF6366F1),  // indigo
    'tech': Color(0xFF6366F1),
    'health': Color(0xFF10B981),      // emerald
    'science': Color(0xFF14B8A6),     // teal
    'sports': Color(0xFFEF4444),      // red
    'entertainment': Color(0xFFEC4899), // pink
    'egypt': Color(0xFFD4A017),       // gold
    'politics': Color(0xFF8B5CF6),    // violet
  };

  static Color forCategory(String category) {
    return _map[category.trim().toLowerCase()] ?? _defaultColor;
  }
}
