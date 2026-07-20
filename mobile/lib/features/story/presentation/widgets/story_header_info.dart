import 'package:flutter/material.dart';

import '../../../../core/models/story.dart';

/// Editorial Header — matches HTML exactly.
///
/// HTML: px-4 md:px-margin-desktop md:w-8/12 mx-auto mb-12 text-center
/// - display-lg-mobile / display-lg title
/// - metadata row: author icon + name, schedule icon + read time, calendar + date
class StoryHeaderInfo extends StatelessWidget {
  const StoryHeaderInfo({
    super.key,
    required this.story,
    required this.author,
    required this.category,
  });

  final StoryDetail story;
  final AuthorSummary author;
  final StoryCategory category;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 0),
      child: Column(
        children: [
          // Title — display-lg-mobile (36px/44px) mobile, display-lg (48px/56px) desktop
          Text(
            story.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: isDesktop ? 48 : 36,
              height: isDesktop ? 56 / 48 : 44 / 36,
              letterSpacing: isDesktop ? -0.02 : -0.01,
              fontWeight: FontWeight.w600,
              color: colors.primary, // text-primary #6a020a
            ),
          ),
          const SizedBox(height: 24),

          // Metadata row
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              // Author
              _MetadataChip(
                icon: Icons.account_circle_outlined,
                label: 'By ${author.name}',
                colors: colors,
              ),
              // Bullet separator (desktop only)
              if (isDesktop)
                Text('•', style: TextStyle(color: colors.onSurfaceVariant)),
              // Reading time
              _MetadataChip(
                icon: Icons.schedule_rounded,
                label: '${story.readingTime ?? 12} min read',
                colors: colors,
              ),
              // Bullet separator (desktop only)
              if (isDesktop)
                Text('•', style: TextStyle(color: colors.onSurfaceVariant)),
              // Publish date
              _MetadataChip(
                icon: Icons.calendar_today_rounded,
                label: story.publishedAt != null
                    ? _formatDate(story.publishedAt!)
                    : '—',
                colors: colors,
              ),
            ],
          ),
          const SizedBox(height: 32), // mb-8 (32px)
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _MetadataChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colors;

  const _MetadataChip({
    required this.icon,
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: colors.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
