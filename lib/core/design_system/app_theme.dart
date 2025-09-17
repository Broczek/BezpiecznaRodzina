import 'package:flutter/material.dart';

// File-level: Centralized application theming and design tokens.
// Provides color constants, light and dark ThemeData, and reusable component styles.

class AppTheme {
  // Color palette used across the app (primary, accent, error).
  // These constants centralize colors for consistent usage throughout widgets and themes.
  static const Color primaryColor = Color(0xFF2C5282);
  static const Color lightPrimaryColor = Color.fromARGB(255, 114, 158, 204);
  static const Color accentColor = Color(0xFF50C878);
  static const Color errorColor = Color(0xFFFF6B6B);

  // Light theme configuration: defines the visual appearance for light mode.
  // Includes typography, colorScheme, AppBar, button styles, inputs and snack bars.
  static const Color lightBackgroundColor = Color(0xFFF5F5F5);
  static const Color lightTextColorPrimary = Color(0xFF333333);
  static const Color lightTextColorSecondary = Color(0xFF666666);
  static const Color lightFieldFillColor = Color(0xFFEAEAEA);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    brightness: Brightness.light,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      error: errorColor,
      background: lightBackgroundColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: lightTextColorPrimary),
      titleTextStyle: TextStyle(
        color: lightTextColorPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: lightTextColorPrimary),
      bodyMedium: TextStyle(color: lightTextColorSecondary),
      headlineMedium: TextStyle(color: lightTextColorPrimary, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: _elevatedButtonTheme(primaryColor),
    outlinedButtonTheme: _outlinedButtonTheme(primaryColor),
    textButtonTheme: _textButtonTheme(primaryColor),
    inputDecorationTheme: _inputDecorationTheme(lightFieldFillColor, primaryColor),
    bottomSheetTheme: _bottomSheetTheme(lightBackgroundColor),
    snackBarTheme: _snackBarTheme(),
  );

  // Dark theme configuration: defines the visual appearance for dark mode.
  // Mirrors the light theme but with colors tuned for dark backgrounds.
  static const Color darkBackgroundColor = Color(0xFF1A202C);
  static const Color darkTextColorPrimary = Color(0xFFEDF2F7);
  static const Color darkTextColorSecondary = Color(0xFFA0AEC0);
  static const Color darkFieldFillColor = Color(0xFF2D3748);
  
  static final ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color.fromARGB(255, 42, 51, 70),
    brightness: Brightness.dark,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.dark(
      primary: lightPrimaryColor,
      secondary: lightPrimaryColor,
      error: errorColor,
      background: darkBackgroundColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: darkTextColorPrimary),
      titleTextStyle: TextStyle(
        color: darkTextColorPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: darkTextColorPrimary),
      bodyMedium: TextStyle(color: darkTextColorSecondary),
      headlineMedium: TextStyle(color: darkTextColorPrimary, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: _elevatedButtonTheme(lightPrimaryColor),
    outlinedButtonTheme: _outlinedButtonTheme(lightPrimaryColor),
    textButtonTheme: _textButtonTheme(lightPrimaryColor),
    inputDecorationTheme: _inputDecorationTheme(darkFieldFillColor, lightPrimaryColor),
    bottomSheetTheme: _bottomSheetTheme(darkBackgroundColor),
    snackBarTheme: _snackBarTheme(),
  );

  // Shared component styles: factory methods that return themed styles for buttons,
  // inputs, bottom sheets and snack bars so styling stays consistent across the app.
  static ElevatedButtonThemeData _elevatedButtonTheme(Color color) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(Color color) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        minimumSize: const Size(double.infinity, 50),
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(Color color) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: color,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(Color fillColor, Color focusColor) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      floatingLabelStyle: TextStyle(color: focusColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: focusColor, width: 2),
      ),
    );
  }
  
  static BottomSheetThemeData _bottomSheetTheme(Color bgColor) {
    return BottomSheetThemeData(
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }
  
  static SnackBarThemeData _snackBarTheme() {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4,
    );
  }
}

