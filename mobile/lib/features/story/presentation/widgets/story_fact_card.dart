import 'package:flutter/material.dart';

/// Reusable Fact Card widget — matches HTML styling exactly.
///
/// HTML: my-12 bg-surface-container-lowest border border-surface-variant
/// rounded-2xl p-6 relative shadow-sm overflow-hidden group
/// - Left accent bar (w-2 h-full bg-primary)
/// - Icon circle (p-3 bg-surface-container-low rounded-full)
/// - Headline, description, optional action button
class StoryFactCard extends StatelessWidget {
  const StoryFactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48), // my-12
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceContainerLowest,
          border: Border.all(color: colors.outlineVariant),
          borderRadius: BorderRadius.circular(16),
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
                width: 8,
                height: double.infinity,
                color: colors.primary,
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon circle
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Icon(icon, color: colors.primary),
                  ),
                  const SizedBox(width: 16),
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colors.onSurfaceVariant),
                        ),
                        if (actionLabel != null) ...[
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: onAction,
                            icon: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                            ),
                            label: Text(actionLabel!),
                            style: TextButton.styleFrom(
                              foregroundColor: colors.primary,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
