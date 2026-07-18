import 'package:flutter/material.dart';

import '../app_colors.dart';

/// Extension point for theme tokens extracted from Stitch.
class AppDesignTokens extends ThemeExtension<AppDesignTokens> {
  const AppDesignTokens({required this.colors});

  final AppColors colors;

  @override
  AppDesignTokens copyWith({AppColors? colors}) {
    return AppDesignTokens(colors: colors ?? this.colors);
  }

  @override
  ThemeExtension<AppDesignTokens> lerp(
    ThemeExtension<AppDesignTokens>? other,
    double t,
  ) {
    // Token objects are discrete; keep current.
    if (other is! AppDesignTokens) return this;
    return this;
  }
}
