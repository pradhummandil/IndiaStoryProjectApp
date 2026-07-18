import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'theme_extensions/app_design_tokens.dart';

/// Production-ready Material 3 theme.
///
/// Constraints (per app rules):
/// - Must use only design-system tokens.
/// - Must support both light & dark.
class AppTheme {
  const AppTheme();

  static ThemeData light() {
    final colors = const AppColors();

    final scheme = ColorScheme.light(
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      surface: colors.surface,
      onSurface: colors.onBackground,
      outline: colors.outline,
      error: colors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.background,
      extensions: <ThemeExtension<dynamic>>[AppDesignTokens(colors: colors)],
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        isDense: true,

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.outlineVariant, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.primary, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.error, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.error, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size.fromHeight(48),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size.fromHeight(48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size.fromHeight(48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: colors.primary),
      ),
      snackBarTheme: SnackBarThemeData(backgroundColor: colors.onBackground),
      dialogTheme: const DialogThemeData(),
      cardTheme: const CardThemeData(),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface.withValues(alpha: 0.6),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
        bodyMedium: ThemeData.light().textTheme.bodyMedium?.copyWith(
          color: colors.onBackground,
        ),
      ),
    );
  }

  static ThemeData dark() {
    final colors = const AppColors();
    final scheme = ColorScheme.dark(
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      surface: colors.surface,
      onSurface: colors.onBackground,
      outline: colors.outline,
      error: colors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.onBackground,
      extensions: <ThemeExtension<dynamic>>[AppDesignTokens(colors: colors)],
    );
  }
}
