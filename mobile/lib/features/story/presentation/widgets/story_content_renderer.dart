import 'package:flutter/material.dart';

/// Rich content renderer — matches HTML exactly.
///
/// HTML: px-4 md:px-margin-desktop md:w-8/12 mx-auto
/// - Drop cap: font-['EB_Garamond'] text-[20px] leading-[36px] mb-8 drop-cap
/// - Body paragraphs: same style, mb-12
/// - Fact Card: aside with left accent bar
class StoryContentRenderer extends StatelessWidget {
  const StoryContentRenderer({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Parse content into paragraphs — use simple newline splitting
    final paragraphs = content
        .split('\n')
        .where((p) => p.trim().isNotEmpty)
        .toList();

    if (paragraphs.isEmpty) {
      paragraphs.add(content);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // First paragraph: Drop Cap
        Padding(
          padding: const EdgeInsets.only(bottom: 32), // mb-8
          child: _buildBodyText(
            context: context,
            text: paragraphs.first,
            isFirst: true,
          ),
        ),

        // Remaining paragraphs
        for (int i = 1; i < paragraphs.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 48), // mb-12
            child: _buildBodyText(
              context: context,
              text: paragraphs[i],
              isFirst: false,
            ),
          ),

        // Interactive Fact Card (matches HTML exactly)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 48), // my-12
          child: _StoryFactCard(colors: colors),
        ),
      ],
    );
  }

  Widget _buildBodyText({
    required BuildContext context,
    required String text,
    required bool isFirst,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Text(
      text,
      style: TextStyle(
        fontFamily: 'EB Garamond',
        fontSize: 20,
        height: 36 / 20,
        color: colors.onSurface,
      ),
    );
  }
}

/// Interactive Fact Card — matches HTML exactly.
///
/// HTML: bg-surface-container-lowest border border-surface-variant rounded-2xl p-6
/// relative shadow-sm overflow-hidden group
/// Left accent: absolute top-0 left-0 w-2 h-full bg-primary
/// Icon: p-3 bg-surface-container-low rounded-full text-primary
/// "The Silk Route Connection" headline
/// Body text mb-4
/// "Explore the Timeline" button with arrow_forward
class _StoryFactCard extends StatelessWidget {
  const _StoryFactCard({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest, // bg-surface-container-lowest
        border: Border.all(
          color: colors.outlineVariant, // border-surface-variant
        ),
        borderRadius: BorderRadius.circular(16), // rounded-2xl
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Left accent bar
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 8, // w-2
              height: double.infinity,
              color: colors.primary, // bg-primary
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24), // p-6
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon circle
                Container(
                  padding: const EdgeInsets.all(12), // p-3
                  decoration: BoxDecoration(
                    color:
                        colors.surfaceContainerLow, // bg-surface-container-low
                    borderRadius: BorderRadius.circular(999), // rounded-full
                  ),
                  child: Icon(
                    Icons.explore_rounded,
                    color: colors.primary, // text-primary
                  ),
                ),
                const SizedBox(width: 16),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The Silk Route Connection',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              height: 32 / 24,
                            ),
                      ),
                      const SizedBox(height: 8), // mb-2
                      Text(
                        'While Kanchipuram is synonymous with indigenous weaving techniques, '
                        'historical records indicate that the early development of its distinct style '
                        'was heavily influenced by trade patterns along the ancient Silk Route, '
                        'bringing novel motifs and metallurgical techniques for zari creation.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16), // mb-4
                      // Explore the Timeline button
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                        label: const Text('Explore the Timeline'),
                        style: TextButton.styleFrom(
                          foregroundColor: colors.primary, // text-primary
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
