import 'package:flutter/material.dart';

import '../../../../design_system/app_colors.dart';

/// DS-backed link-style button.
class AuthLinkButton extends StatelessWidget {
  const AuthLinkButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isPrimary = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final colors = const AppColors();

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: isPrimary ? colors.primary : colors.onSurfaceVariant,
          decoration: TextDecoration.underline,
          decorationThickness: 1,
          decorationColor: isPrimary
              ? colors.primary
              : colors.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
