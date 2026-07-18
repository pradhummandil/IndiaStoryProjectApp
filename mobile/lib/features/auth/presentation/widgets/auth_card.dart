import 'package:flutter/material.dart';

import '../../../../design_system/app_borders.dart';
import '../../../../design_system/app_colors.dart';
import '../../../../design_system/app_radius.dart';
import '../../../../design_system/app_shadows.dart';
import '../../../../design_system/app_spacing.dart';

/// DS-backed premium card used across auth screens.
///
/// No local styling: radius/border/shadow/padding are driven by the Design System.
class AuthCard extends StatelessWidget {
  const AuthCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.s24,
    this.maxWidth = 520,
  });

  final Widget child;
  final double padding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final colors = const AppColors();
    final borders = const AppBorders();
    final radius = AppRadius();
    final shadows = const AppShadows();

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            border: Border.fromBorderSide(borders.card),
            borderRadius: radius.lg,
            boxShadow: [shadows.editorialSoft],
          ),
          child: Padding(padding: EdgeInsets.all(padding), child: child),
        ),
      ),
    );
  }
}
