import 'package:flutter/material.dart';

/// Secondary button implementation based on Stitch HTML.

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leftIcon,
    this.rightIcon,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: scheme.primary, width: 1),
      ),
      onPressed: enabled ? onPressed : null,
      icon: leftIcon ?? const SizedBox.shrink(),
      label: Text(label),
    );
  }
}
