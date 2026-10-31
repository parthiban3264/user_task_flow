import 'package:flutter/material.dart';

/// Colors used across the calculator app.
class AppColors {
  const AppColors._();

  static const Color background = Color(0xFF0F1117);
  static const Color surface = Color(0xFF181B24);
  static const Color surfaceAlt = Color(0xFF222634);
  static const Color primary = Color(0xFF6D5DFB);
  static const Color accent = Color(0xFF22A06B);
  static const Color danger = Color(0xFFE5484D);
  static const Color textPrimary = Color(0xFFF5F6FA);
  static const Color textSecondary = Color(0xFF9AA1B2);
  static const Color divider = Color(0xFF2A2F3D);
}

/// Builds the dark theme used by the app.
ThemeData buildAppTheme() {
  final base = ThemeData.dark(useMaterial3: true);

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
      error: AppColors.danger,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    dividerColor: AppColors.divider,
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
  );
}
