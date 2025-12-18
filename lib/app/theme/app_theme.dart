import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Restore the color options
enum AppThemeColor { deepPurple, green, red, blue, yellow }

class AppTheme {
  // Premium color palettes with gradients
  static const Map<AppThemeColor, List<Color>> gradientColors = {
    AppThemeColor.deepPurple: [Color(0xFF6B4EFF), Color(0xFF9D7BFF)],
    AppThemeColor.green: [Color(0xFF00C9A7), Color(0xFF00D4B5)],
    AppThemeColor.red: [Color(0xFFFF6B6B), Color(0xFFFF8787)],
    AppThemeColor.blue: [Color(0xFF4E93FF), Color(0xFF7BB3FF)],
    AppThemeColor.yellow: [Color(0xFFFFB800), Color(0xFFFFD000)],
  };

  // Premium shadows
  static List<BoxShadow> get premiumShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  // Method to get the seed color for a given theme enum
  static Color _getSeedColor(AppThemeColor themeColor) {
    switch (themeColor) {
      case AppThemeColor.green:
        return const Color(0xFF00C9A7);
      case AppThemeColor.red:
        return const Color(0xFFFF6B6B);
      case AppThemeColor.blue:
        return const Color(0xFF4E93FF);
      case AppThemeColor.yellow:
        return const Color(0xFFFFB800);
      default:
        return const Color(0xFF6B4EFF);
    }
  }

  // Get gradient for theme color
  static LinearGradient getGradient(AppThemeColor themeColor) {
    final colors = gradientColors[themeColor]!;
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // Generic theme builder
  static ThemeData _buildTheme(
    Brightness brightness,
    AppThemeColor themeColor,
  ) {
    final seedColor = _getSeedColor(themeColor);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    final baseTextTheme = brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,

      // Premium Typography with Google Fonts
      textTheme: GoogleFonts.interTextTheme(baseTextTheme).copyWith(
        headlineLarge: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          letterSpacing: -1.0,
          fontSize: 32,
        ),
        headlineMedium: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          fontSize: 28,
        ),
        headlineSmall: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
          fontSize: 24,
        ),
        titleLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          fontSize: 20,
        ),
        titleMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          height: 1.6,
          letterSpacing: 0.1,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          height: 1.5,
          letterSpacing: 0.2,
        ),
      ),

      // Premium Button Theme
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(color: colorScheme.primary, width: 2),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Premium Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: colorScheme.surfaceContainerHighest,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      // Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Premium AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.inter(
          color: colorScheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),

      // Radio Buttons
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.onSurfaceVariant;
        }),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primary,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Premium SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: brightness == Brightness.dark
            ? colorScheme.surface
            : colorScheme.surfaceContainerHighest,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentTextStyle: GoogleFonts.inter(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: GoogleFonts.inter(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: GoogleFonts.inter(
          color: colorScheme.onSurfaceVariant,
          fontSize: 14,
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        showDragHandle: true,
        dragHandleColor: colorScheme.onSurfaceVariant,
      ),

      // Page Transitions Theme (Zoom for premium feel)
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
          TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
        },
      ),
    );
  }

  // Public getters for themes
  static ThemeData getLightTheme(AppThemeColor themeColor) =>
      _buildTheme(Brightness.light, themeColor);
  static ThemeData getDarkTheme(AppThemeColor themeColor) =>
      _buildTheme(Brightness.dark, themeColor);
}
