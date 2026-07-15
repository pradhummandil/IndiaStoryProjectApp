import 'package:flutter/material.dart';

/// Theme construction that uses design tokens.

import 'colors.dart';

ThemeData buildAppTheme({ThemeMode mode = ThemeMode.light}) {
  const scheme = ColorScheme.light(
    primary: isPrimary,
    onPrimary: isOnPrimary,
    surface: isSurface,
    onSurface: isOnBackground,
    outline: isOutline,
    error: isError,
  );

  // Avoid deprecated background/onBackground tokens.
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: scheme,
    scaffoldBackgroundColor: isSurface,
  );
}
