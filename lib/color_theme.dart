import 'package:flutter/material.dart';

class ColorTheme {
  static const Color primaryColor = Color(0xFF4A77F2); // Blue shade
  static const Color secondaryColor = Color(0xFF3498DB); // Lighter blue shade
  static const Color appBarGradientStart = secondaryColor;
  static const Color appBarGradientEnd = primaryColor;
  static const Color successColor = Colors.green;
  static const Color failureColor = Colors.red;
  static const Color infoColor = Colors.orange;

  // Define these as regular variables instead of const
  static final cardBackground = Colors.white.withOpacity(0.6);
  static final inputFieldBackground = Colors.white.withOpacity(0.2);
}
