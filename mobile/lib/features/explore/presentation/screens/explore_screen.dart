import 'package:flutter/material.dart';

import '../widgets/explore_timeline.dart';

/// Explore India / Discovery Engine screen.
///
/// Matches `design/explore_india_production_v2/code.html` exactly.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F3),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  if (!isDesktop) _MobileTopAppBar(),
                  if (isDesktop) _DesktopNavShell(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: isDesktop ? 64 : 16,
                        right: isDesktop ? 64 : 16,
                        top: 32,
                        bottom: isDesktop ? 0 : 96,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1280),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            _HeaderSection(),
                            const SizedBox(height: 48),
                            const ExploreTimeline(),
                            const SizedBox(height: 48),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!isDesktop) _ExploreBottomNav(),
          ],
        ),
      ),
    );
  }
}

class _MobileTopAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu_rounded),
            color: colors.onSurfaceVariant,
          ),
          const Spacer(),
          Text(
            'HERITAGE',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
            color: colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _DesktopNavShell extends StatelessWidget {
  const _DesktopNavShell();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
        boxShadow: [
          BoxShadow(blurRadius: 4, color: Colors.black.withValues(alpha: 0.04)),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 64),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu_rounded),
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'HERITAGE',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DesktopNavLink(
                icon: Icons.home_rounded,
                label: 'Home',
                active: false,
              ),
              const SizedBox(width: 32),
              _DesktopNavLink(
                icon: Icons.explore_rounded,
                label: 'Explore',
                active: true,
              ),
              const SizedBox(width: 32),
              _DesktopNavLink(
                icon: Icons.share_rounded,
                label: 'Share',
                active: false,
              ),
              const SizedBox(width: 32),
              _DesktopNavLink(
                icon: Icons.bookmark_border_rounded,
                label: 'Saved',
                active: false,
              ),
              const SizedBox(width: 32),
              _DesktopNavLink(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                active: false,
              ),
            ],
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(right: 64),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(color: colors.outlineVariant),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search_rounded),
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopNavLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const _DesktopNavLink({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: active
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colors.primary, width: 2),
              ),
            )
          : null,
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: active ? colors.primary : colors.onSurfaceVariant,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: active ? colors.primary : colors.onSurfaceVariant,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              letterSpacing: 0.05,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "India's Discovery Engine",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'EB Garamond',
            fontSize: isDesktop ? 48 : 36,
            height: isDesktop ? 56 / 48 : 44 / 36,
            letterSpacing: isDesktop ? -0.02 : -0.01,
            fontWeight: FontWeight.w600,
            color: colors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Traverse thousands of years of cultural heritage, architectural marvels, and natural history through our curated digital museum.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colors.onSurfaceVariant,
              fontSize: 18,
              height: 28 / 18,
            ),
          ),
        ),
      ],
    );
  }
}

class _ExploreBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(top: BorderSide(color: colors.outlineVariant)),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black.withValues(alpha: 0.04),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                active: false,
                colors: colors,
              ),
              _BottomNavItem(
                icon: Icons.explore_rounded,
                label: 'Explore',
                active: true,
                colors: colors,
              ),
              _BottomNavItem(
                icon: Icons.share_rounded,
                label: 'Share',
                active: false,
                colors: colors,
              ),
              _BottomNavItem(
                icon: Icons.bookmark_border_rounded,
                label: 'Saved',
                active: false,
                colors: colors,
              ),
              _BottomNavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                active: false,
                colors: colors,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final ColorScheme colors;
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? colors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: active ? colors.onPrimary : colors.onSurfaceVariant,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: active ? colors.onPrimary : colors.onSurfaceVariant,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
