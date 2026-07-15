import 'package:flutter/material.dart';

/// Typography tokens.

class IsTypography {
  const IsTypography();

  TextStyle labelSm(ThemeData theme) =>
      theme.textTheme.labelSmall ?? const TextStyle();
  TextStyle labelMd(ThemeData theme) =>
      theme.textTheme.labelMedium ?? const TextStyle();
  TextStyle bodyMd(ThemeData theme) =>
      theme.textTheme.bodyMedium ?? const TextStyle();
  TextStyle bodyLg(ThemeData theme) =>
      theme.textTheme.bodyLarge ?? const TextStyle();
  TextStyle headlineMd(ThemeData theme) =>
      theme.textTheme.headlineMedium ?? const TextStyle();
  TextStyle headlineLg(ThemeData theme) =>
      theme.textTheme.headlineLarge ?? const TextStyle();
  TextStyle displayLg(ThemeData theme) =>
      theme.textTheme.displayLarge ?? const TextStyle();
}
