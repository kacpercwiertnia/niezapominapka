import 'package:flutter/material.dart';

class AppTheme {
  static const Color scaffoldBg = Color(0xFF051621);
  static const Color cardBg = Color(0xFF1C2B36);
  static const Color primary = Color(0xFF61A5FF);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFCFD8DC);

  static ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: scaffoldBg,
    fontFamily: 'SF Pro Display',
    colorScheme: const ColorScheme.dark(
      primary: primary,
      surface: cardBg,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      labelStyle: const TextStyle(color: textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: cardBg,
        foregroundColor: textSecondary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
