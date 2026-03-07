import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typographie Toutim.
///
/// - Titres : Quicksand (bold / semibold)
/// - Corps  : Inter (regular / medium / semibold)
abstract final class AppTypography {
  static TextTheme textTheme(Brightness brightness) {
    final color = brightness == Brightness.light
        ? const Color(0xFF333333)
        : const Color(0xFFE8E8E8);

    return TextTheme(
      // ── Display ──
      displayLarge: GoogleFonts.quicksand(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      displayMedium: GoogleFonts.quicksand(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      displaySmall: GoogleFonts.quicksand(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color,
      ),

      // ── Headline ──
      headlineLarge: GoogleFonts.quicksand(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      headlineMedium: GoogleFonts.quicksand(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      headlineSmall: GoogleFonts.quicksand(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
      ),

      // ── Title ──
      titleLarge: GoogleFonts.quicksand(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      ),

      // ── Body ──
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
      ),

      // ── Label ──
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
}
