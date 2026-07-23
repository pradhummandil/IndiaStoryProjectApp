import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../design_system/app_radius.dart';

class GoogleAppleSocialButton extends StatelessWidget {
  const GoogleAppleSocialButton({
    super.key,
    required this.label,
    required this.assetPath,
    required this.onPressed,
    required this.isGoogle,
    this.width,
    this.isLoading = false,
  });

  final String label;
  final String assetPath;
  final VoidCallback onPressed;
  final bool isGoogle;
  final double? width;
  final bool isLoading;

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
          backgroundColor: isLoading
              ? scheme.surfaceContainerHighest.withValues(alpha: 0.7)
              : scheme.surfaceContainerHighest,
          foregroundColor: isLoading
              ? scheme.onSurfaceVariant.withValues(alpha: 0.5)
              : scheme.onSurfaceVariant,
          side: BorderSide(
            color: isLoading
                ? scheme.outlineVariant.withValues(alpha: 0.5)
                : scheme.outlineVariant,
          ),
          shape: RoundedRectangleBorder(borderRadius: radius.lg),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: scheme.primary,
                ),
              )
            : SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  assetPath,
                  colorFilter: isGoogle
                      ? null
                      : ColorFilter.mode(
                          scheme.onSurfaceVariant,
                          BlendMode.srcIn,
                        ),
                ),
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
