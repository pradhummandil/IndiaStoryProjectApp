import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_radius.dart';

/// Reusable Primary button.
///
/// Consumes only Design System tokens.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final scheme = Theme.of(context).colorScheme;

    return FilledButton(
      onPressed: enabled && !isLoading ? onPressed : null,
      style: FilledButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: AppRadius().lg),
        padding: const EdgeInsets.symmetric(horizontal: 24),
      ),
      child: isLoading
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label, style: themeText(context, scheme)),
    );
  }

  TextStyle themeText(BuildContext context, ColorScheme scheme) {
    return Theme.of(
      context,
    ).textTheme.labelLarge!.copyWith(color: scheme.onPrimary);
  }
}
