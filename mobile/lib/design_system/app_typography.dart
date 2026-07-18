import 'package:flutter/material.dart';

/// Typography tokens extracted from Stitch.
///
/// These methods return TextStyle variants mapped to Material 3.
class AppTypography {
  const AppTypography();

  // Typography variants (Material 3 naming).
  // These are sourced from ThemeData to ensure Light/Dark support.
  TextStyle displayLarge(ThemeData theme) => theme.textTheme.displayLarge!;
  TextStyle displayMedium(ThemeData theme) => theme.textTheme.displayMedium!;
  TextStyle displaySmall(ThemeData theme) => theme.textTheme.displaySmall!;

  TextStyle headlineLarge(ThemeData theme) => theme.textTheme.headlineLarge!;
  TextStyle headlineMedium(ThemeData theme) => theme.textTheme.headlineMedium!;
  TextStyle headlineSmall(ThemeData theme) => theme.textTheme.headlineSmall!;

  TextStyle titleLarge(ThemeData theme) => theme.textTheme.titleLarge!;
  TextStyle titleMedium(ThemeData theme) => theme.textTheme.titleMedium!;
  TextStyle titleSmall(ThemeData theme) => theme.textTheme.titleSmall!;

  TextStyle bodyLarge(ThemeData theme) => theme.textTheme.bodyLarge!;
  TextStyle bodyMedium(ThemeData theme) => theme.textTheme.bodyMedium!;
  TextStyle bodySmall(ThemeData theme) => theme.textTheme.bodySmall!;

  TextStyle labelLarge(ThemeData theme) => theme.textTheme.labelLarge!;
  TextStyle labelMedium(ThemeData theme) => theme.textTheme.labelMedium!;
  TextStyle labelSmall(ThemeData theme) => theme.textTheme.labelSmall!;

  TextStyle caption(ThemeData theme) => theme.textTheme.bodySmall!;

  TextStyle button(ThemeData theme) => theme.textTheme.labelLarge!;

  // Stitch aliases
  TextStyle labelSmUpper(ThemeData theme) =>
      labelSmall(theme).copyWith(letterSpacing: 0.05);

  // Additional precise heading variants used by splash/login.
  TextStyle labelLgUpper(ThemeData theme) =>
      labelLarge(theme).copyWith(letterSpacing: 0.05);

  TextStyle displayLogo(ThemeData theme) =>
      displayLarge(theme).copyWith(letterSpacing: -0.02);
}
