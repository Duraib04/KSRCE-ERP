import 'package:flutter/material.dart';

class KsrColors {
  // Primary KSRCE Brand Colors
  static const Color navyBlue = Color(0xFF003366);
  static const Color darkNavy = Color(0xFF0A1628);
  static const Color midNavy = Color(0xFF0D1F3C);
  static const Color cardDark = Color(0xFF111D35);
  static const Color borderDark = Color(0xFF1E3055);
  
  // Accent Colors
  static const Color gold = Color(0xFFD4A843);
  static const Color goldLight = Color(0xFFE8C96A);
  static const Color accentBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF42A5F5);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF29B6F6);
  
  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xB3FFFFFF); // white70
  static const Color textMuted = Color(0x80FFFFFF); // white50
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: KsrColors.navyBlue,
      brightness: Brightness.light,
      primary: KsrColors.navyBlue,
      secondary: KsrColors.gold,
    ),
    appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      filled: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: KsrColors.darkNavy,
    colorScheme: ColorScheme.dark(
      primary: KsrColors.accentBlue,
      secondary: KsrColors.gold,
      surface: KsrColors.cardDark,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: KsrColors.cardDark,
      foregroundColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: KsrColors.cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: KsrColors.borderDark),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: KsrColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: KsrColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: KsrColors.accentBlue, width: 2),
      ),
      filled: true,
      fillColor: KsrColors.darkNavy,
      labelStyle: const TextStyle(color: KsrColors.textSecondary),
      hintStyle: const TextStyle(color: KsrColors.textMuted),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: KsrColors.accentBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    dividerTheme: const DividerThemeData(color: KsrColors.borderDark),
    popupMenuTheme: const PopupMenuThemeData(color: KsrColors.cardDark),
  );
}
