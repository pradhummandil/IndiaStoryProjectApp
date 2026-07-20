import 'package:flutter/material.dart';

/// Fixed Bottom Action Bar — matches HTML exactly.
///
/// HTML: fixed bottom-0 w-full bg-surface border-t border-surface-variant py-2 px-4 z-50
/// max-w-md mx-auto flex justify-between items-center text-on-surface-variant
/// - Save (bookmark icon + "Save" label)
/// - Share (share icon + "Share" label)
/// - Translate (translate icon + "Translate" label)
/// - Display (format_size icon + "Display" label)
class StoryBottomActionBar extends StatelessWidget {
  const StoryBottomActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface, // bg-surface
        border: Border(
          top: BorderSide(
            color: colors.outlineVariant,
          ), // border-t border-surface-variant
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8, // py-2
            horizontal: 16, // px-4
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 448), // max-w-md
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ActionButton(
                  icon: Icons.bookmark_border_rounded,
                  label: 'Save',
                  colors: colors,
                ),
                _ActionButton(
                  icon: Icons.share_rounded,
                  label: 'Share',
                  colors: colors,
                ),
                _ActionButton(
                  icon: Icons.translate_rounded,
                  label: 'Translate',
                  colors: colors,
                ),
                _ActionButton(
                  icon: Icons.format_size_rounded,
                  label: 'Display',
                  colors: colors,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colors;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64, // w-16
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8), // p-2
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: colors.onSurfaceVariant, size: 24),
              const SizedBox(height: 4), // gap-1
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  height: 16 / 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
