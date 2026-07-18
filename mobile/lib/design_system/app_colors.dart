import 'package:flutter/material.dart';

/// Global App color tokens extracted from Stitch designs.
///
/// Note: these are the only source of truth for app colors.
/// Screens/widgets must consume these tokens via [AppTheme].
class AppColors {
  const AppColors();

  // Base Brand
  Color get primary => const Color(0xFF6A020A);
  Color get onPrimary => const Color(0xFFFFFFFF);

  Color get secondary => const Color(0xFF635D5A);
  Color get onSecondary => const Color(0xFFFFFFFF);
  Color get secondaryContainer => const Color(0xFFE6DED9);
  Color get onSecondaryContainer => const Color(0xFF67625E);

  Color get tertiary => const Color(0xFF735C00);
  Color get onTertiary => const Color(0xFFFFFFFF);
  Color get tertiaryContainer => const Color(0xFFCCA730);

  // Semantic (Status)
  Color get success => const Color(0xFF34A853);
  Color get warning => const Color(0xFFFBBC05);
  Color get error => const Color(0xFFBA1A1A);
  Color get info => const Color(0xFF4285F4);

  // Light/Dark are derived at theme level; tokens here are semantic base colors.
  // Background / Surface
  Color get background => const Color(0xFFF8F5EF);
  Color get onBackground => const Color(0xFF1C1C18);

  Color get surface => const Color(0xFFFCF9F3);
  Color get onSurface => const Color(0xFF1C1C18);

  Color get surfaceContainerHighest => const Color(0xFFE5E2DC);
  Color get surfaceContainerHigh => const Color(0xFFEBE8E2);
  Color get surfaceContainer => const Color(0xFFF0EEE8);
  Color get surfaceContainerLow => const Color(0xFFF6F3ED);
  Color get surfaceContainerLowest => const Color(0xFFFFFFFF);
  Color get surfaceVariant => const Color(0xFFE5E2DC);
  Color get surfaceBright => const Color(0xFFFCF9F3);

  // Border / Divider
  Color get outline => const Color(0xFF8B716E);
  Color get outlineVariant => const Color(0xFFDFBFBC);
  Color get divider => const Color(0xFFDFBFBC);

  // Text colors (semantic)
  Color get textPrimary => const Color(0xFF1C1C18);
  Color get textSecondary => const Color(0xFF58413F);
  Color get textOnSurfaceVariant => const Color(0xFF58413F);
  Color get disabled => const Color(0xFF8B716E);

  // Overlay / Scrim
  Color get overlayPrimary => const Color(0x1A8B1E1E);
  Color get overlayOnSurface => const Color(0x33000000);

  // Backward compatible names used in current auth screens/theme setup.
  Color get onSurfaceVariant => textOnSurfaceVariant;
}
