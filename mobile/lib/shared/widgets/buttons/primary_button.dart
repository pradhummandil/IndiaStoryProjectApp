import 'package:flutter/material.dart';

/// Primary button implementation based on Stitch HTML.

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leftIcon,
    this.rightIcon,
    this.isLoading = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: (enabled && !isLoading) ? onPressed : null,
      icon: leftIcon ?? const SizedBox.shrink(),
      label: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: scheme.onPrimary),
      ),
    );
  }
}
