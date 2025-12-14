import 'package:flutter/material.dart';

class AppTheme {
  static const Color backgroundColor = Color(0xFF110F13);
  static const Color cardBg = Color(0xFF091926);
  static const Color textPrimary = Colors.white;

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: cardBg,
      foregroundColor: textPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      )
    ),
    cardTheme: CardThemeData(
      color: AppTheme.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      )
    ),
  );
}
