import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Newsreader (serif) for headings, Plus Jakarta Sans for everything else.
class AppTypography {
  AppTypography._();

  static TextStyle _serif(
    double size,
    double height,
    FontWeight w, {
    double spacing = 0,
  }) => GoogleFonts.newsreader(
    fontSize: size,
    height: height / size,
    fontWeight: w,
    letterSpacing: size * spacing,
    color: AppColors.onSurface,
  );

  static TextStyle _sans(
    double size,
    double height,
    FontWeight w, {
    double spacing = 0,
  }) => GoogleFonts.plusJakartaSans(
    fontSize: size,
    height: height / size,
    fontWeight: w,
    letterSpacing: size * spacing,
    color: AppColors.onSurface,
  );

  static TextTheme get textTheme => TextTheme(
    displayLarge: _serif(36, 44, FontWeight.w500, spacing: -0.02),
    displayMedium: _serif(30, 38, FontWeight.w500, spacing: -0.015),
    headlineLarge: _serif(26, 34, FontWeight.w600, spacing: -0.01),
    headlineMedium: _serif(22, 28, FontWeight.w600),
    headlineSmall: _serif(18, 24, FontWeight.w600),
    titleMedium: _serif(16, 22, FontWeight.w500, spacing: 0.01),
    bodyLarge: _sans(16, 26, FontWeight.w400),
    bodyMedium: _sans(14, 22, FontWeight.w400),
    bodySmall: _sans(13, 18, FontWeight.w400),
    labelLarge: _sans(13, 16, FontWeight.w600, spacing: 0.02),
    labelMedium: _sans(11, 14, FontWeight.w600, spacing: 0.04),
    labelSmall: _sans(10, 12, FontWeight.w700, spacing: 0.06),
  );
}
