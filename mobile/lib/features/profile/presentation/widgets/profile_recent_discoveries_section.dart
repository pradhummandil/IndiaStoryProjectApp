import 'package:flutter/material.dart';

/// Recent Discoveries section — reading history timeline.
///
/// HTML: mb-stack-lg
/// h2: "Recent Discoveries" with history icon
/// relative pl-6 md:pl-8 border-l border-border space-y-8 py-4
/// Timeline items with dot, date, title, description
class ProfileRecentDiscoveriesSection extends StatelessWidget {
  const ProfileRecentDiscoveriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE8E2D8))),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 24,
                  color: const Color(0xFF5F6368),
                ),
                const SizedBox(width: 12),
                Text(
                  'Recent Discoveries',
                  style: TextStyle(
                    fontFamily: 'EB Garamond',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Timeline
          Padding(
            padding: EdgeInsets.only(left: isDesktop ? 32 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TimelineItem(
                  date: 'Today',
                  title: "The Lost Manuscripts of Timbuktu's Indian Connection",
                  description:
                      'Exploring the trade routes of ideas between continents.',
                  dotColor: colors.primary,
                ),
                const SizedBox(height: 32),
                _TimelineItem(
                  date: 'Yesterday',
                  title: 'Monsoon Ragas: The Sound of Rain',
                  description:
                      'How classical music mapped the changing seasons.',
                  dotColor: const Color(0xFFE5E2E1),
                  dotBorder: true,
                ),
                const SizedBox(height: 32),
                _TimelineItem(
                  date: 'Oct 12, 2023',
                  title: 'Culinary Heritage: The Origins of Filter Coffee',
                  description:
                      'A brew that defined mornings across the southern peninsula.',
                  dotColor: const Color(0xFFE5E2E1),
                  dotBorder: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String date;
  final String title;
  final String description;
  final Color dotColor;
  final bool dotBorder;

  const _TimelineItem({
    required this.date,
    required this.title,
    required this.description,
    required this.dotColor,
    this.dotBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + dot
          SizedBox(
            width: isDesktop ? 8 : 6,
            child: Column(
              children: [
                // Dot
                Container(
                  width: dotBorder ? 12 : 12,
                  height: dotBorder ? 12 : 12,
                  margin: EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotBorder ? colors.surface : dotColor,
                    border: dotBorder
                        ? Border.all(color: const Color(0xFFE8E2D8), width: 1.5)
                        : null,
                    boxShadow: dotBorder
                        ? null
                        : [
                            BoxShadow(
                              blurRadius: 8,
                              color: dotColor.withValues(alpha: 0.3),
                            ),
                          ],
                  ),
                ),
                // Line (extends to fill space)
                Expanded(
                  child: Container(width: 1, color: const Color(0xFFE8E2D8)),
                ),
              ],
            ),
          ),
          SizedBox(width: isDesktop ? 24 : 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date
                Text(
                  date,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF5F6368),
                  ),
                ),
                const SizedBox(height: 4),
                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                // Description
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF5F6368),
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
