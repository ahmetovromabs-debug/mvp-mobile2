// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// App-wide theme builder.
class AppTheme {
  const AppTheme._();

  static ThemeData dark() {
    final textTheme = AppTypography.buildTextTheme(brightness: Brightness.dark);
    const colorScheme = ColorScheme.dark(
      primary: AppColors.brandGreen,
      onPrimary: Color(0xFF062012),
      secondary: AppColors.info,
      onSecondary: Colors.white,
      surface: AppColors.bgElevated,
      onSurface: AppColors.textPrimary,
      error: AppColors.danger,
      onError: Colors.white,
    );
    return _build(
      textTheme: textTheme,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      scaffoldBackground: AppColors.bgBase,
      pillColor: AppColors.bgPill,
      strokeColor: AppColors.stroke,
    );
  }

  static ThemeData light() {
    final textTheme =
        AppTypography.buildTextTheme(brightness: Brightness.light);
    const colorScheme = ColorScheme.light(
      primary: AppColors.brandGreenDeep,
      onPrimary: Colors.white,
      secondary: AppColors.info,
      onSecondary: Colors.white,
      surface: AppColors.bgElevatedLight,
      onSurface: AppColors.textPrimaryLight,
      error: AppColors.danger,
      onError: Colors.white,
    );
    return _build(
      textTheme: textTheme,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      scaffoldBackground: AppColors.bgBaseLight,
      pillColor: AppColors.bgPillLight,
      strokeColor: AppColors.strokeLight,
    );
  }

  static ThemeData _build({
    required TextTheme textTheme,
    required ColorScheme colorScheme,
    required Brightness brightness,
    required Color scaffoldBackground,
    required Color pillColor,
    required Color strokeColor,
  }) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: textTheme,
      fontFamily: AppTypography.bodyFamily,
      splashFactory: NoSplash.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleMedium,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: strokeColor),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: pillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.base,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: strokeColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: strokeColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.brandGreen, width: 1.5),
        ),
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      dividerColor: strokeColor,
      extensions: <ThemeExtension<dynamic>>[
        AppPalette(
          pill: pillColor,
          stroke: strokeColor,
          surfaceElevated: colorScheme.surface,
          textSecondary:
              isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
          textMuted: isDark ? AppColors.textMuted : AppColors.textMutedLight,
          brandGreen: AppColors.brandGreen,
          brandGreenGlow: AppColors.brandGreenGlow,
          brandGreenDeep: AppColors.brandGreenDeep,
        ),
      ],
    );
  }
}

/// Theme extension exposing brand palette beyond [ColorScheme].
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.pill,
    required this.stroke,
    required this.surfaceElevated,
    required this.textSecondary,
    required this.textMuted,
    required this.brandGreen,
    required this.brandGreenGlow,
    required this.brandGreenDeep,
  });

  final Color pill;
  final Color stroke;
  final Color surfaceElevated;
  final Color textSecondary;
  final Color textMuted;
  final Color brandGreen;
  final Color brandGreenGlow;
  final Color brandGreenDeep;

  @override
  AppPalette copyWith({
    Color? pill,
    Color? stroke,
    Color? surfaceElevated,
    Color? textSecondary,
    Color? textMuted,
    Color? brandGreen,
    Color? brandGreenGlow,
    Color? brandGreenDeep,
  }) {
    return AppPalette(
      pill: pill ?? this.pill,
      stroke: stroke ?? this.stroke,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      brandGreen: brandGreen ?? this.brandGreen,
      brandGreenGlow: brandGreenGlow ?? this.brandGreenGlow,
      brandGreenDeep: brandGreenDeep ?? this.brandGreenDeep,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      pill: Color.lerp(pill, other.pill, t)!,
      stroke: Color.lerp(stroke, other.stroke, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      brandGreen: Color.lerp(brandGreen, other.brandGreen, t)!,
      brandGreenGlow: Color.lerp(brandGreenGlow, other.brandGreenGlow, t)!,
      brandGreenDeep: Color.lerp(brandGreenDeep, other.brandGreenDeep, t)!,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
