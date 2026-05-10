import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography tokens.
///
/// - Display (Manrope 700/800) — большие заголовки.
/// - Body (Inter 400/500/600) — основной UI и текст.
/// - Accent (Caveat) — эмоциональные подписи (например, «для дома и офиса»).
class AppTypography {
  const AppTypography._();

  static const String displayFamily = 'Manrope';
  static const String bodyFamily = 'Inter';
  static const String accentFamily = 'Caveat';

  static TextTheme buildTextTheme({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;
    final primary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final secondary =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    final displayBase = TextStyle(
      fontFamily: displayFamily,
      color: primary,
      height: 1.05,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
    );
    final bodyBase = TextStyle(
      fontFamily: bodyFamily,
      color: primary,
      height: 1.45,
      fontWeight: FontWeight.w400,
    );

    return TextTheme(
      displayLarge: displayBase.copyWith(fontSize: 64),
      displayMedium: displayBase.copyWith(fontSize: 48),
      displaySmall: displayBase.copyWith(fontSize: 36),
      headlineLarge:
          displayBase.copyWith(fontSize: 28, fontWeight: FontWeight.w700),
      headlineMedium:
          displayBase.copyWith(fontSize: 22, fontWeight: FontWeight.w700),
      headlineSmall:
          displayBase.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(
        fontFamily: bodyFamily,
        color: primary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleMedium: TextStyle(
        fontFamily: bodyFamily,
        color: primary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleSmall: TextStyle(
        fontFamily: bodyFamily,
        color: primary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      bodyLarge: bodyBase.copyWith(fontSize: 16),
      bodyMedium: bodyBase.copyWith(fontSize: 14),
      bodySmall: bodyBase.copyWith(fontSize: 12, color: secondary),
      labelLarge: TextStyle(
        fontFamily: bodyFamily,
        color: primary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      labelMedium: TextStyle(
        fontFamily: bodyFamily,
        color: secondary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      labelSmall: TextStyle(
        fontFamily: bodyFamily,
        color: secondary,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.6,
      ),
    );
  }

  /// Курсивный акцент (как «для дома и офиса» на главной).
  static const TextStyle accentScript = TextStyle(
    fontFamily: accentFamily,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: 0,
  );
}
