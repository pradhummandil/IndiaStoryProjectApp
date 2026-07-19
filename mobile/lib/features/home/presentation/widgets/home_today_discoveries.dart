import 'package:flutter/material.dart';

import '../../domain/models/home_story.dart';

class HomeTodayDiscoveries extends StatelessWidget {
  const HomeTodayDiscoveries({super.key, required this.discoveries});

  final List<HomeDiscoveryCard> discoveries;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Today\'s Discoveries',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        ...discoveries.map((d) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: _DiscoveryCard(discovery: d),
          );
        }),
      ],
    );
  }
}

class _DiscoveryCard extends StatelessWidget {
  const _DiscoveryCard({required this.discovery});

  final HomeDiscoveryCard discovery;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final vertical = c.maxWidth < 700;
          return vertical
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 220,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.surfaceVariant,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: _DiscoveryContent(discovery: discovery),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        height: 260,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colors.surfaceVariant,
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: _DiscoveryContent(discovery: discovery),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}

class _DiscoveryContent extends StatelessWidget {
  const _DiscoveryContent({required this.discovery});

  final HomeDiscoveryCard discovery;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.35),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: Text(
                  discovery.category,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                const Icon(Icons.schedule_rounded, size: 16),
                const SizedBox(width: 4),
                Text(
                  discovery.readTime,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          discovery.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          discovery.description,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: colors.surfaceVariant,
              child: const Icon(Icons.person_outline_rounded, size: 16),
            ),
            const SizedBox(width: 10),
            Text(
              'By ${discovery.author}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bookmark_border_rounded),
              color: colors.primary,
            ),
          ],
        ),
      ],
    );
  }
}
