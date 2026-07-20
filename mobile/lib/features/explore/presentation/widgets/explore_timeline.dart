import 'package:flutter/material.dart';

/// Discover by Era Timeline — matches HTML exactly.
///
/// HTML structure:
/// - Section header: "Discover by Era" headline-md + "View Full Timeline" link
/// - Timeline container: relative w-full h-48 md:h-64, bg-surface-container-lowest,
///   rounded-lg border border-outline-variant, overflow-hidden shadow-sm
/// - Decorative timeline track: absolute top-1/2 w-full h-0.5 bg-tertiary-fixed-dim
/// - Horizontal scrollable eras with snap-x snap-mandatory
///
/// 5 eras:
/// 1. Prehistoric (c. 2M - 3300 BCE)
/// 2. Ancient (c. 3300 BCE - 500 CE) — active, larger dot, primary-container
/// 3. Medieval (c. 500 CE - 1526 CE)
/// 4. Colonial (1526 CE - 1947 CE)
/// 5. Modern (1947 CE - Present)
class ExploreTimeline extends StatelessWidget {
  const ExploreTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          children: [
            Expanded(
              child: Text(
                'Discover by Era',
                style: TextStyle(
                  fontFamily: 'EB Garamond',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: colors.onSurface,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward, size: 14),
              label: Text(
                'View Full Timeline',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.primary,
                  letterSpacing: 0.1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Timeline container
        Container(
          height: isDesktop ? 256 : 192,
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.outlineVariant),
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black.withValues(alpha: 0.04),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Decorative timeline track
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      height: 2,
                      color: const Color(0xFFCDCCAB), // tertiary-fixed-dim
                    ),
                  ),
                ),
                // Eras horizontal scroll
                ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 32 : 16,
                  ),
                  children: [
                    _EraItem(
                      title: 'Prehistoric',
                      period: 'c. 2M - 3300 BCE',
                      isActive: false,
                      colors: colors,
                    ),
                    _EraSpacer(),
                    _EraItem(
                      title: 'Ancient',
                      period: 'c. 3300 BCE - 500 CE',
                      isActive: true,
                      colors: colors,
                    ),
                    _EraSpacer(),
                    _EraItem(
                      title: 'Medieval',
                      period: 'c. 500 CE - 1526 CE',
                      isActive: false,
                      colors: colors,
                    ),
                    _EraSpacer(),
                    _EraItem(
                      title: 'Colonial',
                      period: '1526 CE - 1947 CE',
                      isActive: false,
                      colors: colors,
                    ),
                    _EraSpacer(),
                    _EraItem(
                      title: 'Modern',
                      period: '1947 CE - Present',
                      isActive: false,
                      colors: colors,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Single era item on the timeline.
/// Matches HTML: flex-col items-center, snap-center, group cursor-pointer
/// - Dot: w-4 h-4 rounded-full, bg-secondary-fixed, border-2 border-primary
///   Active: w-6 h-6, bg-primary-container, inner white dot, shadow-sm
/// - Label: font-label-lg text-label-lg font-bold
/// - Period: font-label-sm text-label-sm text-on-surface-variant
class _EraItem extends StatelessWidget {
  final String title;
  final String period;
  final bool isActive;
  final ColorScheme colors;

  const _EraItem({
    required this.title,
    required this.period,
    required this.isActive,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 192,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dot
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? 24 : 16,
            height: isActive ? 24 : 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? const Color(0xFF8B1E1E) // primary-container
                  : const Color(0xFFE9E1DC), // secondary-fixed
              border: Border.all(color: colors.primary, width: 2),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.black.withValues(alpha: 0.1),
                      ),
                    ]
                  : null,
            ),
            child: isActive
                ? Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isActive ? colors.primary : colors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          // Period
          Text(
            period,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// Spacer between era items — 64px wide in HTML.
class _EraSpacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 64);
  }
}
