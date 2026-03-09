import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Extension pour obtenir les couleurs adaptatives selon le mode clair/sombre.
extension AppColorsExtension on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;

  Color get appTextPrimary =>
      _isDark ? AppColors.darkText : AppColors.textPrimary;

  Color get appTextSecondary =>
      _isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

  Color get appTextTertiary =>
      _isDark ? AppColors.darkTextTertiary : AppColors.textTertiary;

  Color get appBorder => _isDark ? AppColors.darkBorder : AppColors.border;

  Color get appSurface => _isDark ? AppColors.darkSurface : AppColors.surface;

  Color get appSurfaceAlt =>
      _isDark ? AppColors.darkSurfaceAlt : AppColors.surfaceAlt;
}
