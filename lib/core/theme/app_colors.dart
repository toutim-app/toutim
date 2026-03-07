import 'package:flutter/material.dart';

/// Palette de couleurs Toutim.
///
/// Color-coding par catégorie de collection,
/// plus les couleurs utilitaires (texte, surfaces, erreur).
abstract final class AppColors {
  // ── Couleurs principales (catégories) ──────────────────────────

  /// Interface, navigation, actions primaires
  static const blue = Color(0xFF2D9CDB);

  /// Culture, savoir (livres, vinyles)
  static const teal = Color(0xFF2ABFBF);

  /// Divertissement, actions secondaires
  static const orange = Color(0xFFF2994A);

  /// Validation, succès, nature/finance
  static const green = Color(0xFF27AE60);

  /// Favoris, cartes fidélité (aspect gold)
  static const yellow = Color(0xFFF2C94C);

  /// Erreur, suppression, danger
  static const red = Color(0xFFEB5757);

  /// Catégories spéciales
  static const purple = Color(0xFF9B51E0);

  // ── Texte — jamais de noir pur (#000000) ───────────────────────

  static const textPrimary = Color(0xFF333333);
  static const textSecondary = Color(0xFF666666);
  static const textTertiary = Color(0xFF999999);

  // ── Surfaces (light) ───────────────────────────────────────────

  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF8F9FA);
  static const border = Color(0xFFE8E8E8);

  // ── Surfaces (dark) ────────────────────────────────────────────

  static const darkSurface = Color(0xFF1A1A2E);
  static const darkSurfaceAlt = Color(0xFF222236);
  static const darkBorder = Color(0xFF2E2E44);
  static const darkText = Color(0xFFE8E8E8);

  // ── Couleurs par nom de template ───────────────────────────────

  static const Map<String, Color> templateColors = {
    'blue': blue,
    'teal': teal,
    'orange': orange,
    'green': green,
    'yellow': yellow,
    'red': red,
    'purple': purple,
  };

  /// Liste ordonnée pour le sélecteur de couleur utilisateur.
  static const List<Color> palette = [
    blue,
    teal,
    green,
    orange,
    yellow,
    red,
    purple,
  ];

  /// Clés correspondantes à [palette], pour stocker la couleur en DB.
  static const List<String> paletteKeys = [
    'blue',
    'teal',
    'green',
    'orange',
    'yellow',
    'red',
    'purple',
  ];
}
