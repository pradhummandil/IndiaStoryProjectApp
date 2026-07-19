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
import '../widgets/home_search_fab.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final featured = ref.watch(featuredStoryProvider);
    final continueStories = ref.watch(continueReadingProvider);
    final discoveries = ref.watch(todayDiscoveriesProvider);
    final streak = ref.watch(readingStreakProvider);
    final collections = ref.watch(curatedCollectionsProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: colors.surface),
                ),
              ),
            ),
            Column(
              children: [
                _TopAppBar(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth >= 1024;
                      final isTablet =
                          constraints.maxWidth >= 600 && !isDesktop;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 84),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop
                                ? 64
                                : isTablet
                                ? 32
                                : 16,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              HomeFeaturedCarousel(
                                title: featured.title,
                                category: featured.category,
                                description: featured.description,
                                onReadStory: () {},
                              ),
                              const SizedBox(height: 24),
                              if (isDesktop) ...[
                                _ReadingStreakRow(streak: streak),
                                const SizedBox(height: 20),
                                _MainTwoColumn(
                                  collections: collections,
                                  continueStories: continueStories,
                                  discoveries: discoveries,
                                ),
                              ] else ...[
                                _ReadingStreakRow(streak: streak),
                                const SizedBox(height: 20),
                                HomeContinueReadingCarousel(
                                  stories: continueStories,
                                ),
                                const SizedBox(height: 28),
                                HomeTodayDiscoveries(discoveries: discoveries),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const HomeSearchFab(),
            const HomeBottomNavigation(),
          ],
        ),
      ),
    );
  }
}

class _TopAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surface,
      elevation: 0,
      child: SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu_rounded),
                color: colors.onSurfaceVariant,
                onPressed: () {},
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'HERITAGE',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search_rounded),
                color: colors.onSurfaceVariant,
                onPressed: () {},
              ),
            ],
          ),
        ),
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

class _MainTwoColumn extends StatelessWidget {
  const _MainTwoColumn({
    required this.collections,
    required this.continueStories,
    required this.discoveries,
  });

  final List<HomeCuratedCollection> collections;
  final List<HomeStory> continueStories;
  final List<HomeDiscoveryCard> discoveries;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: Column(
            children: [
              HomeContinueReadingCarousel(stories: continueStories),
              const SizedBox(height: 28),
              HomeTodayDiscoveries(discoveries: discoveries),
            ],
          ),
        ),
        const SizedBox(width: 24),
        SizedBox(
          width: 320,
          child: HomeCuratedCollectionsSidebar(collections: collections),
        ),
      ],
    );
  }
}
