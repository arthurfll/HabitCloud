import 'package:flutter/material.dart';

/// Blue/white with soft gradients, matching the site's Bootstrap primary (#0d6efd) — one of the
/// colors in the shared Category palette (Core/Source/Models/CategoryOptions.cs).
class AppColors {
  AppColors._();

  static const primaryBlue = Color(0xFF0D6EFD);
  static const deepBlue = Color(0xFF0B5AD6);
  static const skyBlue = Color(0xFF5B9CFF);
  static const white = Color(0xFFFFFFFF);
  static const surface = Color(0xFFF4F8FF);

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepBlue, primaryBlue, skyBlue],
  );

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surface, white],
  );
}

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primaryBlue,
    brightness: Brightness.light,
    primary: AppColors.primaryBlue,
    surface: AppColors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
      ),
    ),
  );
}
