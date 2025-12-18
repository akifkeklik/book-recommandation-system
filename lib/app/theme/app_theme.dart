import 'package:flutter/material.dart';

// Restore the color options
enum AppThemeColor {
  deepPurple, 
  green, 
  red,
  blue,
  yellow,
}

class AppTheme {
  // Method to get the seed color for a given theme enum
  static Color _getSeedColor(AppThemeColor themeColor) {
    switch (themeColor) {
      case AppThemeColor.green:
        return Colors.teal;
      case AppThemeColor.red:
        return Colors.red.shade400;
      case AppThemeColor.blue:
        return Colors.blue.shade400;
      case AppThemeColor.yellow:
        return Colors.amber.shade700;
      default:
        return Colors.deepPurple;
    }
  }

  // Generic theme builder
  static ThemeData _buildTheme(Brightness brightness, AppThemeColor themeColor) {
    final seedColor = _getSeedColor(themeColor);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      
      // Typography
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
        titleLarge: TextStyle(fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(height: 1.5),
      ),

      // Button Theme
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: colorScheme.surfaceContainerHighest, 
        margin: EdgeInsets.zero,
      ),

      // Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: colorScheme.primary,
        type: BottomNavigationBarType.fixed,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      
      // Radio Buttons
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.onSurfaceVariant;
        }),
      ),
    );
  }

  // Public getters for themes
  static ThemeData getLightTheme(AppThemeColor themeColor) => _buildTheme(Brightness.light, themeColor);
  static ThemeData getDarkTheme(AppThemeColor themeColor) => _buildTheme(Brightness.dark, themeColor);
}
