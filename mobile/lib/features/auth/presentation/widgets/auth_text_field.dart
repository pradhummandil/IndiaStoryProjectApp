import 'package:flutter/material.dart';

import '../../../../design_system/app_colors.dart';
import '../../../../design_system/app_typography.dart';
import '../../../../design_system/app_spacing.dart';

/// DS-backed labeled input field.
/// Uses [Theme] InputDecorationTheme so there is no local InputDecoration styling.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.prefixIcon,
    this.errorText,
    this.onChanged,
  });

  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? prefixIcon;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = const AppColors();
    final typography = const AppTypography();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: typography
              .labelLarge(Theme.of(context))
              .copyWith(color: colors.onSurfaceVariant),
        ),
        SizedBox(height: AppSpacing.s8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}
