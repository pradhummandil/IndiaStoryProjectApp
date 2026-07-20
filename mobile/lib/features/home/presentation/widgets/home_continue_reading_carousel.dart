import 'package:flutter/material.dart';

import '../../domain/models/home_story.dart';

/// "Continue Reading" horizontal carousel, matching HTML exactly.
///
/// HTML: design/home_discover_production/code.html
/// - Title: font-headline-lg-mobile (28px/36px, weight 600) on mobile,
///          font-headline-lg (32px/40px, weight 600) on desktop
/// - Cards: 280px wide mobile, 320px wide desktop, snap-start
/// - "12 min left" badge: bg-surface/90 backdrop-blur-sm, label-sm
/// - Category label: label-sm, uppercase, text-primary
/// - Title: title-lg (22px/28px, weight 500)
/// - Progress bar: h-1 (4px), bg-surface-variant, filled with primary
/// - Progress labels: label-sm, on-surface-variant
class HomeContinueReadingCarousel extends StatelessWidget {
  const HomeContinueReadingCarousel({super.key, required this.stories});

  final List<HomeStory> stories;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    if (stories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Continue Reading',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: isDesktop ? 32 : 28,
            height: isDesktop ? 40 / 32 : 36 / 28,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 8),
            scrollDirection: Axis.horizontal,
            itemCount: stories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, i) {
              final story = stories[i];
              return _ContinueStoryCard(story: story);
            },
          ),
        ),
      ],
    );
  }
}

class _ContinueStoryCard extends StatefulWidget {
  const _ContinueStoryCard({required this.story});

  final HomeStory story;

  @override
  State<_ContinueStoryCard> createState() => _ContinueStoryCardState();
}

class _ContinueStoryCardState extends State<_ContinueStoryCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    final cardWidth = isDesktop ? 320.0 : 280.0;

    final card = Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image area
          SizedBox(
            height: 128,
            child: Stack(
              children: [
                // Background placeholder
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.surfaceVariant,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                  ),
                ),
                // "12 min left" badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.story.readTime,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        height: 16 / 11,
                      ),
                    ),
                  ),
                ),
                // Hover zoom effect (web only)
                AnimatedScale(
                  scale: _hover ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  child: const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category label
                  Text(
                    widget.story.category.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.primary,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      height: 16 / 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    widget.story.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      height: 28 / 22,
                    ),
                  ),
                  const Spacer(),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Container(
                      height: 4,
                      color: colors.surfaceVariant,
                      child: FractionallySizedBox(
                        widthFactor:
                            (widget.story.progressPercent.clamp(0, 100) / 100),
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: colors.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Progress labels
                  Row(
                    children: [
                      Text(
                        '${widget.story.progressPercent}% Complete',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          height: 16 / 11,
                        ),
                      ),
                      const Spacer(),
                      if (widget.story.lastRead.isNotEmpty)
                        Text(
                          widget.story.lastRead,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: colors.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                                height: 16 / 11,
                              ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: card,
    );
  }
}
