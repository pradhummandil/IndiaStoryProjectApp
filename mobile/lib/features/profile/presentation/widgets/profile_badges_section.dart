import 'package:flutter/material.dart';

/// Achievements & Badges section — horizontal scrollable row of badges.
///
/// HTML: mb-section-gap (~120px)
/// h2: "Honors & Badges" with military_tech icon
/// flex overflow-x-auto gap-6 pb-4 no-scrollbar
/// 4 badges: Heritage Guardian (gold), Science Explorer (madder), Avid Chronicler (tertiary), Master Weaver (locked)
class ProfileBadgesSection extends StatelessWidget {
  const ProfileBadgesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 120),
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
                  Icons.emoji_events_outlined,
                  size: 24,
                  color: const Color(0xFF755B00),
                ),
                const SizedBox(width: 12),
                Text(
                  'Honors & Badges',
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
          // Badges scrollable row
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                _BadgeWidget(
                  icon: Icons.account_balance_rounded,
                  bgColor: const Color(0xFFFAF6E9),
                  iconColor: const Color(0xFF755B00),
                  label: 'Heritage Guardian',
                  isLocked: false,
                  showStar: true,
                ),
                const SizedBox(width: 24),
                _BadgeWidget(
                  icon: Icons.biotech_rounded,
                  bgColor: const Color(0xFFF2E8E8),
                  iconColor: const Color(0xFF6A020A),
                  label: 'Science Explorer',
                  isLocked: false,
                  showStar: false,
                ),
                const SizedBox(width: 24),
                _BadgeWidget(
                  icon: Icons.menu_book_rounded,
                  bgColor: const Color(0xFFC3E8FF),
                  iconColor: const Color(0xFF00364B),
                  label: 'Avid Chronicler',
                  isLocked: false,
                  showStar: false,
                ),
                const SizedBox(width: 24),
                _BadgeWidget(
                  icon: Icons.lock_rounded,
                  bgColor: const Color(0xFFE5E2E1),
                  iconColor: const Color(0xFF5F6368),
                  label: 'Master Weaver',
                  isLocked: true,
                  showStar: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeWidget extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final String label;
  final bool isLocked;
  final bool showStar;

  const _BadgeWidget({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.label,
    this.isLocked = false,
    this.showStar = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: 128,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
              border: Border.all(
                color: isLocked
                    ? const Color(0xFFE8E2D8)
                    : const Color(0xFF755B00).withValues(alpha: 0.3),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, size: 40, color: iconColor),
                if (showStar)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE8E2D8)),
                      ),
                      child: Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: const Color(0xFFECC246),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              letterSpacing: 0.05,
              fontWeight: FontWeight.w600,
              color: isLocked ? const Color(0xFF5F6368) : colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
