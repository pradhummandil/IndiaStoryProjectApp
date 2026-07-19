import 'package:flutter/material.dart';

import '../../../../design_system/app_radius.dart';

class GoogleAppleSocialButton extends StatelessWidget {
  const GoogleAppleSocialButton({
    super.key,
    required this.label,
    required this.assetPath,
    required this.onPressed,
    required this.isGoogle,
    this.width,
  });

  final String label;
  final String assetPath;
  final VoidCallback onPressed;
  final bool isGoogle;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = AppRadius();

    return SizedBox(
      width: width,
      height: 48,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: scheme.surfaceContainerHighest,
          foregroundColor: scheme.onSurfaceVariant,
          side: BorderSide(color: scheme.outlineVariant),
          shape: RoundedRectangleBorder(borderRadius: radius.lg),
          // mimic HTML: no extra elevation; keep DS shadow available if needed
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: ImageIcon(
          AssetImage(assetPath),
          color: isGoogle ? null : scheme.onSurfaceVariant,
          size: 20,
        ),
        label: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            letterSpacing: 0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
