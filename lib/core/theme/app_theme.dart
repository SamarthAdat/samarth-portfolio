import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Builds the [ThemeData] applied at the root of the app.
class AppTheme {
  const AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Arial',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.dark,
        surface: AppColors.card,
      ),
      textTheme: _textTheme,
    );
  }

  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      color: AppColors.text,
      fontSize: 42,
      fontWeight: FontWeight.w800,
      height: 1.15,
      letterSpacing: -0.8,
    ),
    headlineLarge: TextStyle(
      color: AppColors.text,
      fontSize: 32,
      fontWeight: FontWeight.w800,
      height: 1.2,
    ),
    headlineMedium: TextStyle(
      color: AppColors.text,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.25,
    ),
    titleLarge: TextStyle(
      color: AppColors.text,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 1.35,
    ),
    titleMedium: TextStyle(
      color: AppColors.text,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1.4,
    ),
    bodyLarge: TextStyle(color: AppColors.muted, fontSize: 16, height: 1.75),
    bodyMedium: TextStyle(color: AppColors.muted, fontSize: 14, height: 1.65),
    labelLarge: TextStyle(
      color: AppColors.text,
      fontSize: 13,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    ),
  );
}
