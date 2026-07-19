import 'package:flutter/material.dart';

import '../../domain/models/home_story.dart';

class HomeReadingStreakCard extends StatelessWidget {
  const HomeReadingStreakCard({super.key, required this.streak});

  final HomeReadingStreak streak;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final isWide = c.maxWidth >= 700;

          return isWide
              ? Row(
                  children: [
                    _StreakLeft(colors: colors, streak: streak),
                    const Spacer(),
                    _StreakProgress(colors: colors, streak: streak),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StreakLeft(colors: colors, streak: streak),
                    const SizedBox(height: 14),
                    _StreakProgress(colors: colors, streak: streak),
                  ],
                );
        },
      ),
    );
  }
}

class _StreakLeft extends StatelessWidget {
  const _StreakLeft({required this.colors, required this.streak});

  final ColorScheme colors;
  final HomeReadingStreak streak;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colors.primaryContainer.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Icon(Icons.local_fire_department_rounded, size: 26),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${streak.days} Day Streak',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              streak.message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ],
    );
  }
}

class _StreakProgress extends StatelessWidget {
  const _StreakProgress({required this.colors, required this.streak});

  final ColorScheme colors;
  final HomeReadingStreak streak;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Level 2: ${streak.level}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                '${streak.xp} / ${streak.xpMax} XP',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 8,
              width: double.infinity,
              color: colors.surfaceVariant,
              child: FractionallySizedBox(
                widthFactor: streak.progressPercent,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: colors.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
