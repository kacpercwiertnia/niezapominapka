import 'package:flutter/material.dart';

class AppTheme {
  static const Color backgroundColor = Color(0xFF110F13);
  static const Color cardBg = Color(0xFF091926);
  static const Color inputButtonBg = Color(0xFF253746);
  static const Color inputButtonSelectedBg = Color(0xFF4A6278);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFCFD8DC);
  static const Color primary = Color(0xFF61A5FF);

  static ThemeData theme = ThemeData.dark(useMaterial3: true).copyWith(
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

    iconTheme: const IconThemeData(color: textPrimary),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textPrimary),
    ),

    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: inputButtonBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),

      hintStyle: const TextStyle(color: textSecondary),
      labelStyle: const TextStyle(
        color: textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),

      floatingLabelStyle: const TextStyle(color: textPrimary),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(inputButtonBg),
        foregroundColor: const WidgetStatePropertyAll(textSecondary),
        elevation: const WidgetStatePropertyAll(0),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );

  static ButtonStyle get unselectedElevatedButtonStyle => ButtonStyle(
    backgroundColor: const WidgetStatePropertyAll(inputButtonBg),
    foregroundColor: const WidgetStatePropertyAll(textSecondary),
    elevation: const WidgetStatePropertyAll(0),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    ),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    textStyle: const WidgetStatePropertyAll(
      TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    ),
  );

  // Styl Wybrany - kopiuje bazowy i zmienia tylko tło oraz kolor tekstu na biały
  static ButtonStyle get selectedElevatedButtonStyle => unselectedElevatedButtonStyle.copyWith(
    backgroundColor: const WidgetStatePropertyAll(inputButtonSelectedBg),
    foregroundColor: const WidgetStatePropertyAll(Colors.white),
    elevation: const WidgetStatePropertyAll(2), // Opcjonalnie lekki cień dla wyróżnienia
  );
}


