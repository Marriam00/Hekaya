import 'package:flutter/material.dart';

/// All colors come from the "Literary Salon" DESIGN.md (Stitch export).
/// Change a color here and it changes everywhere in the app.
class AppColors {
  AppColors._();

  // Surfaces (the paper-like backgrounds)
  static const surface = Color(0xFFFFF8F6);
  static const surfaceDim = Color(0xFFE4D7D4);
  static const surfaceBright = Color(0xFFFFF8F6);
  static const surfaceLowest = Color(0xFFFFFFFF);
  static const surfaceLow = Color(0xFFFFF1ED);
  static const surfaceContainer = Color(0xFFF9EBE7);
  static const surfaceHigh = Color(0xFFF3E5E2);
  static const surfaceHighest = Color(0xFFEDE0DC);
  static const surfaceTint = Color(0xFF9C432F);

  // Text ("ink")
  static const onSurface = Color(0xFF211A18);
  static const onSurfaceVariant = Color(0xFF56423E);
  static const inverseSurface = Color(0xFF362F2D);
  static const inverseOnSurface = Color(0xFFFCEEEA);

  // Lines
  static const outline = Color(0xFF89726D);
  static const outlineVariant = Color(0xFFDCC1BB);

  // Primary: terracotta
  static const primary = Color(0xFF933C29);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFB2533E);
  static const onPrimaryContainer = Color(0xFFFFF1EE);
  static const inversePrimary = Color(0xFFFFB4A4);
  static const primaryFixed = Color(0xFFFFDAD3);
  static const primaryFixedDim = Color(0xFFFFB4A4);
  static const onPrimaryFixed = Color(0xFF3D0600);
  static const onPrimaryFixedVariant = Color(0xFF7D2C1A);

  // Secondary: sage green
  static const secondary = Color(0xFF51634E);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFD1E5CB);
  static const onSecondaryContainer = Color(0xFF556752);
  static const secondaryFixed = Color(0xFFD4E8CE);
  static const secondaryFixedDim = Color(0xFFB8CCB3);
  static const onSecondaryFixed = Color(0xFF0F1F0F);
  static const onSecondaryFixedVariant = Color(0xFF3A4B38);

  // Tertiary: warm brown
  static const tertiary = Color(0xFF754F27);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFF91673C);
  static const onTertiaryContainer = Color(0xFFFFF2E9);
  static const tertiaryFixed = Color(0xFFFFDCBD);
  static const tertiaryFixedDim = Color(0xFFF0BD8B);
  static const onTertiaryFixed = Color(0xFF2C1600);
  static const onTertiaryFixedVariant = Color(0xFF623F18);

  // Errors
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);
}
