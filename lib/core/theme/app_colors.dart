import 'package:flutter/material.dart';

/// The single source of truth for the palette.
///
/// Widgets read colours from here (or from `Theme.of(context)`), never as
/// inline hex literals.
class AppColors {
  const AppColors._();

  static const Color background = Color(0xFF121212);
  static const Color card = Color(0xFF1E1E1F);
  static const Color cardLight = Color(0xFF2A2A2B);
  static const Color border = Color(0xFF383838);
  static const Color text = Color(0xFFF7F7F7);
  static const Color muted = Color(0xFFB7B7B7);
  static const Color softMuted = Color(0xFF8D8D8D);
  static const Color accent = Color(0xFFFFDB70);
  static const Color accentDark = Color(0xFFB38B20);
  static const Color error = Color(0xFFFF8A8A);

  static const Color shadow = Color(0x66000000);
  static const Color softShadow = Color(0x55000000);
  static const Color subtleShadow = Color(0x33000000);
  static const Color accentGlow = Color(0x33FFDB70);

  /// Gradient behind the tab bar.
  static const List<Color> navigationGradient = [
    Color(0xFF2A2A2C),
    Color(0xFF222224),
  ];

  /// Gradient behind the "Engineering Profile" intro card.
  static const List<Color> introGradient = [
    Color(0xFF2B2A23),
    Color(0xFF232323),
    Color(0xFF1E1E1F),
  ];

  /// Gradient behind the featured project card.
  static const List<Color> featuredGradient = [
    Color(0xFF3B3216),
    Color(0xFF24231D),
    Color(0xFF1E1E1F),
  ];

  /// Mid and base tones shared by the hover-glow cards.
  static const Color glowCardMid = Color(0xFF252527);
  static const Color glowCardMidAlt = Color(0xFF2A2A2C);
  static const Color glowCardBase = Color(0xFF1E1E1F);
}
