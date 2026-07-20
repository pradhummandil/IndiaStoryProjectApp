import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/home_story.dart';

// ignore: unused_import
import '../../domain/models/home_models.dart';
import '../providers/home_providers.dart';
import '../widgets/home_bottom_navigation.dart';
import '../widgets/home_featured_carousel.dart';
import '../widgets/home_reading_streak_card.dart';
import '../widgets/home_continue_reading_carousel.dart';
import '../widgets/home_today_discoveries.dart';
import '../widgets/home_curated_collections_sidebar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeScreenDataProvider);
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5EF),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Main scrollable content
            Positioned.fill(
              child: Column(
                children: [
                  // TopAppBar — matches HTML exactly
                  _TopAppBar(isDesktop: isDesktop),
                  // Desktop top navigation bar (hidden on mobile)
                  if (isDesktop) _DesktopNavBar(),
                  Expanded(
                    child: homeAsync.when(
                      data: (data) => _HomeBody(data: data),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => _ErrorRetry(
                        message: error.toString(),
                        onRetry: () => ref.invalidate(homeScreenDataProvider),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Mobile BottomNavBar only
            if (!isDesktop) const HomeBottomNavigation(),
          ],
        ),
      ),
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 48, color: colors.error),
            const SizedBox(height: 16),
            Text(
              'Could not load home data',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final HomeScreenData data;

  const _HomeBody({required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        final isWide = boxConstraints.maxWidth >= 1024;
        final isMedium = boxConstraints.maxWidth >= 600 && !isWide;

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 84),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Section — full width, max container width centered
              SizedBox(
                width: double.infinity,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1280),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide
                          ? 64
                          : isMedium
                          ? 32
                          : 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Hero carousel with responsive height
                        SizedBox(
                          height: isWide
                              ? boxConstraints.maxHeight * 0.7
                              : boxConstraints.maxHeight * 0.6,
                          child: HomeFeaturedCarousel(
                            title: data.featuredStory.title,
                            category: data.featuredStory.category,
                            description: data.featuredStory.description,
                            onReadStory: () {},
                            imageUrl: data.featuredStory.imageUrl,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Main grid: 8 cols main + 4 cols sidebar on desktop
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: isWide
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 64),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Main content column (8/12)
                              Expanded(
                                flex: 8,
                                child: Column(
                                  children: [
                                    _ReadingStreakRow(
                                      streak: data.readingStreak,
                                    ),
                                    const SizedBox(height: 20),
                                    _MainContent(
                                      continueStories: data.continueReading,
                                      discoveries: data.todayDiscoveries,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),
                              // Sidebar column (4/12)
                              SizedBox(
                                width: 320,
                                child: HomeCuratedCollectionsSidebar(
                                  collections: data.curatedCollections,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMedium ? 32 : 16,
                        ),
                        child: Column(
                          children: [
                            _ReadingStreakRow(streak: data.readingStreak),
                            const SizedBox(height: 20),
                            HomeContinueReadingCarousel(
                              stories: data.continueReading,
                            ),
                            const SizedBox(height: 28),
                            HomeTodayDiscoveries(
                              discoveries: data.todayDiscoveries,
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Desktop top navigation bar — hidden on mobile.
/// Matches HTML: fixed top-right, Home (active + underline), Explore, Saved, Profile
class _DesktopNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 64,
      color: colors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _DesktopNavLink(
            label: 'Home',
            active: true,
            colors: colors,
            textTheme: textTheme,
          ),
          _DesktopNavLink(
            label: 'Explore',
            colors: colors,
            textTheme: textTheme,
          ),
          _DesktopNavLink(label: 'Saved', colors: colors, textTheme: textTheme),
          _DesktopNavLink(
            label: 'Profile',
            colors: colors,
            textTheme: textTheme,
          ),
          const SizedBox(width: 64),
        ],
      ),
    );
  }
}

class _DesktopNavLink extends StatelessWidget {
  final String label;
  final bool active;
  final ColorScheme colors;
  final TextTheme textTheme;

  const _DesktopNavLink({
    required this.label,
    this.active = false,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: active
                ? const Border(
                    bottom: BorderSide(color: Colors.transparent, width: 2),
                  )
                : null,
          ),
          child: Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: active ? colors.primary : colors.onSurfaceVariant,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

/// TopAppBar — matches HTML exactly.
/// Fixed top, h-16 (64px), border-b border-outline-variant, menu + HERITAGE title + search
class _TopAppBar extends StatelessWidget {
  final bool isDesktop;

  const _TopAppBar({this.isDesktop = false});

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
          // Menu button (left)
          if (!isDesktop)
            IconButton(
              icon: const Icon(Icons.menu_rounded),
              color: colors.onSurfaceVariant,
              onPressed: () {},
            )
          else
            const SizedBox(width: 64),
          if (!isDesktop) const Spacer(),
          // Centered "HERITAGE" title
          Text(
            'HERITAGE',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          if (!isDesktop) const Spacer(),
          // Search button (right)
          if (!isDesktop)
            IconButton(
              icon: const Icon(Icons.search_rounded),
              color: colors.onSurfaceVariant,
              onPressed: () {},
            )
          else
            const SizedBox(width: 64),
        ],
      ),
    );
  }
}

class _ReadingStreakRow extends StatelessWidget {
  const _ReadingStreakRow({required this.streak});

  final HomeReadingStreak streak;

  @override
  Widget build(BuildContext context) {
    return HomeReadingStreakCard(streak: streak);
  }
}

class _MainContent extends StatelessWidget {
  final List<HomeStory> continueStories;
  final List<HomeDiscoveryCard> discoveries;

  const _MainContent({
    required this.continueStories,
    required this.discoveries,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeContinueReadingCarousel(stories: continueStories),
        const SizedBox(height: 28),
        HomeTodayDiscoveries(discoveries: discoveries),
      ],
    );
  }
}
