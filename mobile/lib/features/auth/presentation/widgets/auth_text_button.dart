import 'package:flutter/material.dart';

import '../../../../design_system/app_colors.dart';

/// Shared link-style button used across auth screens.
class AuthTextButton extends StatelessWidget {
  const AuthTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isPrimary = true,
    this.fontSize,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final colors = const AppColors();
    final style = Theme.of(context).textTheme.labelLarge?.copyWith(
      color: isPrimary ? colors.primary : colors.onSurfaceVariant,
      fontSize: fontSize,
    );

    return TextButton(
      onPressed: onPressed,
      child: Text(label, style: style),
    );
  }
}
