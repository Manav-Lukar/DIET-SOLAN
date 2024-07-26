import 'package:flutter/material.dart';

class ColorTheme {
  // Primary colors
  static const Color primaryColor = Color(0xffe6f7ff); // Dark Blue
  static const Color secondaryColor = Color(0xffe6f7ff); // Light Blue

  // Gradient colors for AppBar
  static const Color appBarGradientStart = secondaryColor;
  static const Color appBarGradientEnd = primaryColor;

  // Colors for different UI elements
  static const Color successColor = Colors.black;
  static const Color failureColor = Colors.red;
  static const Color infoColor = Colors.orange;

  // Background and card colors
  static final Color pageBackgroundStart = Color(0xFFE0F7FA); // Light Cyan
  static final Color pageBackgroundEnd = Color(0xFFB2EBF2); // Lighter Cyan
  static final Color inputFieldBackground = Color(0xFFFFFFFF).withOpacity(0.2); // Light with opacity
  static final Color cardBackground = Color(0xFFFFFFFF).withOpacity(0.6); // White with opacity

  // Dropdown colors
  static const Color dropdownBackground = Color(0xFFFFFFFF); // White background
  static const Color dropdownTextColor = Color.fromARGB(255, 1, 6, 6); // Teal color for text

  // Accent color used for emphasis
  static const Color accentColor = Color(0xFF00796B); // Teal color
  static const Color iconColor = accentColor; // Same as accent color for icons
}
