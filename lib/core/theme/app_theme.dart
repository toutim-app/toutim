import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Fournit les ThemeData light et dark de Toutim.
abstract final class AppTheme {
  // ── Light ────────────────────────────────────────────────────────

  static ThemeData get light {
    final base = FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: AppColors.blue,
        primaryContainer: Color(0xFFD6EFFF),
        secondary: AppColors.teal,
        secondaryContainer: Color(0xFFD2F5F5),
        tertiary: AppColors.orange,
        tertiaryContainer: Color(0xFFFFE4CC),
        error: AppColors.red,
        errorContainer: Color(0xFFFFDAD6),
      ),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 4,
      subThemesData: _subThemes,
      useMaterial3: true,
    );

    return base.copyWith(
      textTheme: AppTypography.textTheme(Brightness.light),
      scaffoldBackgroundColor: AppColors.surfaceAlt,
      dividerColor: AppColors.border,
    );
  }

  // ── Dark ─────────────────────────────────────────────────────────

  static ThemeData get dark {
    final base = FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: Color(0xFF5BB8E8),
        primaryContainer: Color(0xFF1A3A5C),
        secondary: Color(0xFF4DD4D4),
        secondaryContainer: Color(0xFF1A3D3D),
        tertiary: Color(0xFFF5AD6E),
        tertiaryContainer: Color(0xFF5C3A1A),
        error: Color(0xFFFF8A80),
        errorContainer: Color(0xFF5C1A1A),
      ),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 10,
      subThemesData: _subThemes,
      useMaterial3: true,
    );

    return base.copyWith(
      textTheme: AppTypography.textTheme(Brightness.dark),
      scaffoldBackgroundColor: AppColors.darkSurface,
      dividerColor: AppColors.darkBorder,
    );
  }

  // ── Sub-themes partagés ──────────────────────────────────────────

  static const _subThemes = FlexSubThemesData(
    // Boutons
    elevatedButtonRadius: 12,
    filledButtonRadius: 12,
    outlinedButtonRadius: 12,
    textButtonRadius: 12,

    // Cards
    cardRadius: 16,
    cardElevation: 0,

    // Inputs
    inputDecoratorRadius: 12,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorUnfocusedHasBorder: true,

    // FAB
    fabRadius: 16,
    fabUseShape: true,

    // Dialogs
    dialogRadius: 20,

    // Bottom sheet
    bottomSheetRadius: 20,

    // Chips
    chipRadius: 10,

    // Navigation
    bottomNavigationBarElevation: 0,
    navigationBarIndicatorRadius: 12,
  );
}
