import 'package:flutter/material.dart';

/// Hero Section — matches HTML exactly.
///
/// HTML: w-full object-cover max-h-[70vh] md:max-h-[80vh] aspect-[4/3] md:aspect-video
class StoryHeroImage extends StatelessWidget {
  const StoryHeroImage({super.key, this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: isDesktop
            ? MediaQuery.of(context).size.height * 0.8
            : MediaQuery.of(context).size.height * 0.7,
      ),
      child: AspectRatio(
        aspectRatio: isDesktop ? 16 / 9 : 4 / 3,
        child: Container(
          color: colors.surfaceContainerLow, // bg-surface-container-low
          child: imageUrl != null
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _placeholder(colors),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _placeholder(colors);
                  },
                )
              : _placeholder(colors),
        ),
      ),
    );
  }

  Widget _placeholder(ColorScheme colors) {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 64,
        color: colors.onSurfaceVariant.withValues(alpha: 0.3),
      ),
    );
  }
}
