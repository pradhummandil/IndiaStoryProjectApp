import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/providers.dart';
import '../../../home/domain/models/home_story.dart';
import '../../domain/models/home_models.dart';

// ── Home Screen Data ─────────────────────────────────────────────────

/// Aggregate of all data needed by the home screen, mapped from the API.
class HomeScreenData {
  final HomeStory featuredStory;
  final HomeReadingStreak readingStreak;
  final List<HomeStory> continueReading;
  final List<HomeDiscoveryCard> todayDiscoveries;
  final List<HomeCuratedCollection> curatedCollections;

  const HomeScreenData({
    required this.featuredStory,
    required this.readingStreak,
    this.continueReading = const [],
    this.todayDiscoveries = const [],
    this.curatedCollections = const [],
  });
}

/// Fetches home screen data from the backend API.
final homeScreenDataProvider = FutureProvider<HomeScreenData>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  final home = await repo.getHome();

  // ── Featured Story ─────────────────────────────────────────────────
  final featured = home.featuredStory;
  final featuredStory = HomeStory(
    title: featured?.title ?? 'The Eternal Dawn: Secrets of the Taj Mahal',
    category: 'Featured Story',
    description:
        featured?.excerpt ??
        'Discover the untold architectural marvels and hidden histories woven into the pristine white marble of India\'s most iconic monument.',
    readTime: featured?.readingTime != null
        ? '${featured!.readingTime} min read'
        : '—',
    progressPercent: 0,
    lastRead: '',
    imageUrl: featured?.imageUrl,
  );

  // ── Reading Streak ─────────────────────────────────────────────────
  final readingStreak = HomeReadingStreak(
    days: 7,
    level: 'Explorer',
    xp: 350,
    xpMax: 500,
    message: 'You\'re uncovering India\'s soul. Keep it up!',
    progressPercent: 0.7,
  );

  // ── Continue Reading ───────────────────────────────────────────────
  final continueReading = home.continueReading.isEmpty
      ? home.latestStories
            .take(2)
            .map(
              (s) => HomeStory(
                title: s.title,
                category: s.tags.isNotEmpty ? s.tags.first.name : 'Heritage',
                description: s.excerpt ?? '',
                readTime: s.readingTime != null
                    ? '${s.readingTime} min left'
                    : '—',
                progressPercent: 0,
                lastRead: '',
                imageUrl: s.imageUrl,
              ),
            )
            .toList()
      : home.continueReading
            .map(
              (cr) => HomeStory(
                title: cr.story.title,
                category: cr.story.tags.isNotEmpty
                    ? cr.story.tags.first.name
                    : 'Heritage',
                description: cr.story.excerpt ?? '',
                readTime: cr.story.readingTime != null
                    ? '${cr.story.readingTime} min left'
                    : '—',
                progressPercent: cr.progressPercent,
                lastRead: _timeAgo(cr.lastReadAt),
                imageUrl: cr.story.imageUrl,
              ),
            )
            .toList();

  // ── Today's Discoveries (trending / latest stories) ────────────────
  final discoverySources = home.trendingStories.isNotEmpty
      ? home.trendingStories
      : home.latestStories.take(4).toList();

  final discoveries = discoverySources
      .map(
        (s) => HomeDiscoveryCard(
          category: s.tags.isNotEmpty ? s.tags.first.name : 'Heritage',
          readTime: s.readingTime != null ? '${s.readingTime} min read' : '—',
          title: s.title,
          description: s.excerpt ?? '',
          author: s.author?.name ?? 'India Story Project',
          imageUrl: s.imageUrl,
        ),
      )
      .toList();

  // ── Curated Collections ───────────────────────────────────────────
  final collections = home.collections.isEmpty
      ? [
          const HomeCuratedCollection(title: 'Mughal Architecture'),
          const HomeCuratedCollection(title: 'Ancient Sciences'),
          const HomeCuratedCollection(title: 'Textile Heritage'),
          const HomeCuratedCollection(title: 'The Spice Routes'),
        ]
      : home.collections
            .map((c) => HomeCuratedCollection(title: c.name))
            .toList();

  return HomeScreenData(
    featuredStory: featuredStory,
    readingStreak: readingStreak,
    continueReading: continueReading,
    todayDiscoveries: discoveries,
    curatedCollections: collections,
  );
});

/// Simple relative-time helper.
String _timeAgo(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return 'Last read ${diff.inDays ~/ 7}w ago';
}
