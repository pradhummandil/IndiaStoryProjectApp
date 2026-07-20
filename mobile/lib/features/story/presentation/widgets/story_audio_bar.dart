import 'package:flutter/material.dart';

/// Audio Narration Control Bar — matches HTML exactly.
///
/// HTML: bg-surface-container border border-surface-variant rounded-2xl p-4
/// flex items-center justify-between shadow-sm max-w-md mx-auto
/// hover:bg-surface-container-high transition-colors cursor-pointer
/// - Play button (w-12 h-12 bg-primary rounded-full flex items-center justify-center)
/// - "Listen to Story" + "Narrated by [author]"
/// - Graphic equalizer icon
class StoryAudioBar extends StatelessWidget {
  const StoryAudioBar({super.key, required this.authorName});

  final String authorName;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 448), // max-w-md = 448px
        margin: const EdgeInsets.symmetric(horizontal: 0),
        padding: const EdgeInsets.all(16), // p-4
        decoration: BoxDecoration(
          color: colors.surfaceContainer, // bg-surface-container
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
        child: Row(
          children: [
            // Play button
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.primary, // bg-primary
                borderRadius: BorderRadius.circular(999), // rounded-full
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow_rounded),
                color: colors.onPrimary, // text-on-primary
                iconSize: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Listen to Story',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Narrated by $authorName',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Graphic equalizer icon
            Icon(Icons.graphic_eq_rounded, color: colors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
