import 'package:flutter/material.dart';

/// Profile Header Section — avatar, name, bio, stats bento grid.
///
/// HTML: flex flex-col md:flex-row items-center md:items-start gap-stack-lg mb-section-gap
/// Avatar: w-32 h-32 md:w-48 md:h-48 rounded-full border-2 border-border shadow-sm
/// Stats: grid grid-cols-2 md:grid-cols-4 gap-4
class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Padding(
      padding: const EdgeInsets.only(bottom: 120), // mb-section-gap (~120px)
      child: Column(
        crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          // Avatar + Info row (flex-col md:flex-row)
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AvatarSection(colors: colors),
                const SizedBox(width: 32),
                Expanded(child: _InfoSection(colors: colors, isDesktop: isDesktop)),
              ],
            )
          else
            Column(
              children: [
                const _AvatarSection(),
                const SizedBox(height: 32),
                _InfoSection(colors: colors, isDesktop: isDesktop),
              ],
            ),
        ],
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final ColorScheme? colors;

  const _AvatarSection({this.colors});

  @override
  Widget build(BuildContext context) {
    final c = colors ?? Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Container(
      width: isDesktop ? 192 : 128,
      height: isDesktop ? 192 : 128,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE8E2D8), width: 2), // border
        boxShadow: [
          BoxShadow(blurRadius: 4, color: Colors.black.withValues(alpha: 0.08)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9999),
        child: Image.network(
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAxqer5lxkuS0ItqymMUGlyHefhjgdk-3VwMXfOgd5Vh0ilmaQkEaJAmXKOa-yDJvu0TBamX0VnpyYbOZSMASi6ogIk8JBsi-2fs2RuJADvtec729ftteXubrzzc435xKIuCm5Q8WQfdPWH7IwY7QAwViEuAlSu0R4u9tR13nIutdfxmQTAmVymTZJw6a7icGm_8pGZ1Tf8D0RZ1kjPQgaKcb1-E89pIo2IbbmIfx-gme6FoUN5QmPRWg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: c.primaryContainer,
            child: Icon(Icons.person_rounded, size: isDesktop ? 80 : 48, color: c.onPrimaryContainer),
          ),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final ColorScheme colors;
  final bool isDesktop;

  const _InfoSection({required this.colors, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        // Name + Settings button row
        Row(
          mainAxisAlignment: isDesktop ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
          children: [
            Text(
              'Arundhati Roy',
              style: TextStyle(
                fontFamily: 'EB Garamond',
                fontSize: isDesktop ? 32 : 40,
                fontWeight: FontWeight.w700,
                letterSpacing: isDesktop ? -0.02 : -0.01,
                color: colors.primary,
              ),
            ),
            if (isDesktop)
              const SizedBox.shrink()
            else
              const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 8),
        // Settings button — hidden on mobile (shown inline in HTML)
        if (!isDesktop)
          Center(
            child: _SettingsButton(colors: colors),
          ),
        if (!isDesktop)
          const SizedBox(height: 8),
        // Bio
        Text(
          'Archivist of forgotten tales, chronicler of the subcontinent\'s hidden heritage. Passionate about architecture, textile history, and oral traditions.',
          textAlign: isDesktop ? TextAlign.start : TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF5F6368), // text-secondary
          ),
        ),
        const SizedBox(height: 32),
        // Settings button (desktop — inline after bio)
        if (isDesktop)
          Align(
            alignment: Alignment.centerLeft,
            child: _SettingsButton(colors: colors),
          ),
        if (isDesktop)
          const SizedBox(height: 24),
        // Stats Bento Grid
        _StatsGrid(colors: colors),
      ],
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final ColorScheme colors;

  const _SettingsButton({required this.colors});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
          side: BorderSide(color: const Color(0xFFE8E2D8)), // border
        ),
      ),
      icon: const Icon(Icons.settings_rounded, size: 20),
      label: Text(
        'Settings',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          letterSpacing: 0.05,
          fontWeight: FontWeight.w600,
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final ColorScheme colors;

  const _StatsGrid({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Row 1
        Row(
          children: [
            Expanded(child: _StatCard(colors: colors, value: '42', label: 'Stories Shared')),
            const SizedBox(width: 16),
            Expanded(child: _StatCard(colors: colors, value: '128', label: 'Bookmarks')),
          ],
        ),
        const SizedBox(height: 16),
        // Row 2
        Row(
          children: [
            Expanded(child: _StatCard(colors: colors, value: '1.2k', label: 'Followers')),
            const SizedBox(width: 16),
            Expanded(child: _StatCard(colors: colors, value: '340', label: 'Following')),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final ColorScheme colors;
  final String value;
  final String label;

  const _StatCard({required this.colors, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12), // rounded-xl
        border: Border.all(color: const Color(0xFFE8E2D8)), // border
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black.withValues(alpha: 0.02),
          ),
        ],
      ),
      child: Column(
        children: [
          // Stat value
          Text(
            value,
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 4),
          // Label
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              letterSpacing: 0.05,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF5F6368), // text-secondary
            ),
          ),
        ],
      ),
    );
  }
}
