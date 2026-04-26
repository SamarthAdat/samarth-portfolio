import 'package:flutter/material.dart';

class AppTheme {
  static const Color bg = Color(0xFF121212);
  static const Color card = Color(0xFF1E1E1F);
  static const Color cardLight = Color(0xFF2A2A2B);
  static const Color border = Color(0xFF383838);
  static const Color text = Color(0xFFF7F7F7);
  static const Color muted = Color(0xFFB7B7B7);
  static const Color softMuted = Color(0xFF8D8D8D);
  static const Color accent = Color(0xFFFFDB70);
  static const Color accentDark = Color(0xFFB38B20);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg,
      fontFamily: 'Arial',
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: Brightness.dark,
        surface: card,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: text,
          fontSize: 42,
          fontWeight: FontWeight.w800,
          height: 1.15,
          letterSpacing: -0.8,
        ),
        headlineLarge: TextStyle(
          color: text,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          color: text,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
        titleLarge: TextStyle(
          color: text,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.35,
        ),
        titleMedium: TextStyle(
          color: text,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          height: 1.4,
        ),
        bodyLarge: TextStyle(color: muted, fontSize: 16, height: 1.75),
        bodyMedium: TextStyle(color: muted, fontSize: 14, height: 1.65),
        labelLarge: TextStyle(
          color: text,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
