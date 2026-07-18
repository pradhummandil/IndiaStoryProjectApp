import 'package:flutter/material.dart';

import '../../../../design_system/app_colors.dart';
import '../../../../design_system/app_typography.dart';
import '../../../../design_system/app_spacing.dart';

/// DS-backed editorial section (title/subtitle + spacing).
class AuthSection extends StatelessWidget {
  const AuthSection({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = const AppColors();
    final typography = const AppTypography();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: typography.headlineSmall(Theme.of(context))),
        if (subtitle != null) ...[
          SizedBox(height: AppSpacing.s12),
          Text(
            subtitle!,
            style: typography
                .bodyMedium(Theme.of(context))
                .copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}
