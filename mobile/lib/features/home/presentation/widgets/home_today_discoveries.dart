import 'package:flutter/material.dart';

import '../../domain/models/home_story.dart';

/// "Today's Discoveries" editorial cards, matching HTML exactly.
///
/// HTML: design/home_discover_production/code.html
/// - Title with bottom border (border-b border-outline-variant/30 pb-2)
/// - Category badge: border border-primary/30 px-2 py-0.5 rounded-sm
/// - Reading time with schedule icon
/// - Alternating image left/right on desktop (md:order-last)
/// - Author row with avatar circle + name
/// - Bookmark button
class HomeTodayDiscoveries extends StatelessWidget {
  const HomeTodayDiscoveries({super.key, required this.discoveries});

  final List<HomeDiscoveryCard> discoveries;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title with bottom border (matches HTML: border-b border-outline-variant/30 pb-2)
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: colors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Text(
            "Today's Discoveries",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 24),
        ...discoveries.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: _DiscoveryCard(discovery: entry.value),
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
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final isWide = c.maxWidth >= 768;

          if (!isWide) {
            // Mobile: stacked layout
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 250,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.surfaceVariant,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: _DiscoveryContent(discovery: discovery),
                ),
              ],
            );
          }

          // Desktop: side-by-side with alternating layout
          final cardIndex = discovery.hashCode; // use discovery identity
          final imageOnLeft = cardIndex.isEven;

          return Row(
            children: [
              if (imageOnLeft) _DiscoveryImage(colors: colors),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _DiscoveryContent(discovery: discovery),
                ),
              ),
              if (!imageOnLeft) _DiscoveryImage(colors: colors),
            ],
          );
        },
      ),
    );
  }
}

class _DiscoveryImage extends StatelessWidget {
  const _DiscoveryImage({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: SizedBox(
        height: 250,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surfaceVariant,
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(4),
            ),
          ),
        ),
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
        // Category badge + reading time row
        Row(
          children: [
            // Category badge: border border-primary/30 px-2 py-0.5 rounded-sm
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                discovery.category,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Reading time with schedule icon
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 14,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  discovery.readTime,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Title
        Text(
          discovery.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        // Description
        Text(
          discovery.description,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),
        // Author row + bookmark button
        Row(
          children: [
            // Author avatar
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Icon(Icons.person_rounded, size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              'By ${discovery.author}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            // Bookmark button
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bookmark_border_rounded),
              color: colors.primary,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ],
    );
  }
}
