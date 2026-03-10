import 'package:flutter/material.dart';

/// Temas da aplicação (Light e Dark)
class AppTheme {
  // Cores Light Mode
  static const _lightPrimary = Color(0xFF1565C0);
  static const _lightBackground = Color(0xFFF5F5F5);
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _lightOnBackground = Color(0xFF121212);

  // Cores Dark Mode
  static const _darkPrimary = Color(0xFF64B5F6);
  static const _darkPrimaryDark = Color(0xFF42A5F5);
  static const _darkBackground = Color(0xFF121212);
  static const _darkSurface = Color(0xFF1E1E1E);
  static const _darkOnBackground = Color(0xFFE0E0E0);

  // Cores de Status (iguais em ambos modos)
  static const _successColor = Color(0xFF4CAF50);
  static const _warningColor = Color(0xFFFFA726);
  static const _errorColor = Color(0xFFEF5350);

  /// Tema Light (padrão)
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _lightPrimary,
      brightness: Brightness.light,
      primary: _lightPrimary,
      primaryContainer: _lightPrimary,
      secondary: const Color(0xFFFFB300),
      tertiary: _successColor,
      background: _lightBackground,
      surface: _lightSurface,
      onBackground: _lightOnBackground,
      onSurface: _lightOnBackground,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _lightPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: _lightSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _lightPrimary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: _lightPrimary),
    ),
  );

  /// Tema Dark (novo!)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _darkPrimary,
      brightness: Brightness.dark,
      primary: _darkPrimary,
      primaryContainer: _darkPrimaryDark,
      secondary: const Color(0xFFFFB300),
      tertiary: _successColor,
      background: _darkBackground,
      surface: _darkSurface,
      onBackground: _darkOnBackground,
      onSurface: _darkOnBackground,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _darkSurface,
      foregroundColor: _darkOnBackground,
      elevation: 1,
      shadowColor: Colors.black26,
    ),
    cardTheme: CardThemeData(
      color: _darkSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _darkPrimary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkPrimary,
        foregroundColor: _darkBackground,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: _darkPrimary),
    ),
    scaffoldBackgroundColor: _darkBackground,
    dialogBackgroundColor: _darkSurface,
  );

  /// Retorna a cor primária baseado no tema
  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  /// Retorna a cor de fundo baseado no tema
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  /// Retorna a cor de surface baseado no tema
  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  /// Retorna se está em dark mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Cores de sucesso/aviso/erro (consistent across themes)
  static Color getSuccessColor(BuildContext context) => _successColor;
  static Color getWarningColor(BuildContext context) => _warningColor;
  static Color getErrorColor(BuildContext context) => _errorColor;
}
