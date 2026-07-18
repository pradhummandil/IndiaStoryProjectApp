import 'package:flutter/material.dart';

import '../../design_system/app_theme.dart';

ThemeData buildAppTheme() {
  // Source of truth: Stitch design tokens via the Design System.
  // ThemeData must be constructed only through AppTheme.
  return AppTheme.light();
}
