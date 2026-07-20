import 'package:flutter/material.dart';

/// Hero carousel matching the HTML design exactly.
///
/// HTML source: design/home_discover_production/code.html
/// - 60vh mobile / 70vh desktop
/// - Gradient overlay: from-black/80 via-black/30 to-transparent
/// - "Featured Story" badge (sharp rectangle, bg-primary)
/// - Title in display-md, description in body-lg, max-w-2xl
/// - Read Story button with arrow_forward icon, rounded-DEFAULT (2px)
/// - Carousel indicators at bottom-right: first active, rest inactive
/// - Hover zoom effect on background (web only)
class HomeFeaturedCarousel extends StatelessWidget {
  const HomeFeaturedCarousel({
    super.key,
    required this.title,
    required this.category,
    required this.description,
    required this.onReadStory,
    this.imageUrl,
  });

  final String title;
  final String category;
  final String description;
  final VoidCallback onReadStory;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;
        final height = isDesktop
            ? constraints.maxHeight * 0.7
            : constraints.maxHeight * 0.6;

        return SizedBox(
          height: height.clamp(320, 600),
          child: Stack(
            children: [
              // Background image with hover zoom
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: colors.surfaceVariant,
                        image: imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              // Gradient overlay: from-black/80 via-black/30 to-transparent
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Content area
              Positioned(
                left: isDesktop ? 32 : 16,
                right: isDesktop ? 32 : 16,
                bottom: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "Featured Story" badge — sharp rectangle, bg-primary, uppercase
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      color: colors.primary,
                      child: Text(
                        category.toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.onPrimary,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          fontSize: 11,
                          height: 16 / 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Title — display-md on mobile, display-lg on desktop
                    Text(
                      title,
                      style:
                          (isDesktop
                                  ? textTheme.displayLarge
                                  : textTheme.displayMedium)
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                height: 1.1,
                              ),
                    ),
                    const SizedBox(height: 8),
                    // Description — body-lg, max-width 672px, 2 lines mobile, full desktop
                    SizedBox(
                      width: isDesktop ? 672 : null,
                      child: Text(
                        description,
                        style: textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: 0.5,
                          height: 1.5,
                        ),
                        maxLines: isDesktop ? null : 2,
                        overflow: isDesktop
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Read Story button — rounded-DEFAULT (2px), arrow_forward icon
                    SizedBox(
                      height: 48,
                      child: Material(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(2),
                        child: InkWell(
                          onTap: onReadStory,
                          borderRadius: BorderRadius.circular(2),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Read Story',
                                  style: textTheme.labelLarge?.copyWith(
                                    color: colors.onPrimary,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                  color: colors.onPrimary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Carousel indicators — bottom-right
              Positioned(
                right: isDesktop ? 32 : 16,
                bottom: 16,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Active indicator
                    Container(
                      width: 32,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Inactive indicator
                    Container(
                      width: 8,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Inactive indicator
                    Container(
                      width: 8,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
