import 'package:flutter/material.dart';

/// Brand color tokens for МВП — Мастер в помощь.
///
/// Source of truth: design system from the marketing site
/// https://dist-wtczuair.devinapps.com/ — neon-green accent on a deep
/// black canvas with elevated card surfaces.
class AppColors {
  const AppColors._();

  // Brand
  static const Color brandGreen = Color(0xFF5FFF8E);
  static const Color brandGreenGlow = Color(0x595FFF8E); // 35% opacity
  static const Color brandGreenDeep = Color(0xFF1FAA4D);

  // Dark surfaces (primary theme)
  static const Color bgBase = Color(0xFF0A0B0E);
  static const Color bgElevated = Color(0xFF14161B);
  static const Color bgPill = Color(0xFF1A1D24);
  static const Color stroke = Color(0xFF22262E);

  // Light surfaces (light theme)
  static const Color bgBaseLight = Color(0xFFF6F7F9);
  static const Color bgElevatedLight = Color(0xFFFFFFFF);
  static const Color bgPillLight = Color(0xFFEDEFF3);
  static const Color strokeLight = Color(0xFFE2E5EB);

  // Text — dark theme
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A6B0);
  static const Color textMuted = Color(0xFF6B7280);

  // Text — light theme
  static const Color textPrimaryLight = Color(0xFF0A0B0E);
  static const Color textSecondaryLight = Color(0xFF4B5563);
  static const Color textMutedLight = Color(0xFF8A93A1);

  // Semantic
  static const Color success = brandGreen;
  static const Color warning = Color(0xFFFFB547);
  static const Color danger = Color(0xFFFF5C5C);
  static const Color info = Color(0xFF5CB8FF);
}
