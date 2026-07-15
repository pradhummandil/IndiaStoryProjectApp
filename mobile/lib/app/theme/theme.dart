import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  final seed = const Color(0xFF7C4DFF);
  final scheme = ColorScheme.fromSeed(seedColor: seed);

  // Keep this theme lightweight; the reusable shared theme will be added in
  // the shared component library milestone.
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
    ),
  );
}
