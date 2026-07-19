import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/home_story.dart';

// Offline: mock data only (no backend integration per requirements).

final featuredStoryProvider = Provider<HomeStory>((ref) {
  return const HomeStory(
    title: 'The Eternal Dawn: Secrets of the Taj Mahal',
    category: 'Featured Story',
    description:
        'Discover the untold architectural marvels and hidden histories woven into the pristine white marble of India\'s most iconic monument.',
    readTime: '—',
    progressPercent: 0,
    lastRead: '',
  );
});

final readingStreakProvider = Provider<HomeReadingStreak>((ref) {
  return const HomeReadingStreak(
    days: 7,
    level: 'Explorer',
    xp: 350,
    xpMax: 500,
    message: 'You\'re uncovering India\'s soul. Keep it up!',
    progressPercent: 0.7,
  );
});

final continueReadingProvider = Provider<List<HomeStory>>((ref) {
  return const [
    HomeStory(
      title: "The Geometry of Water: Gujarat's Stepwells",
      category: 'Architecture',
      description: '',
      readTime: '12 min left',
      progressPercent: 45,
      lastRead: 'Last read yesterday',
    ),
    HomeStory(
      title: 'Stargazers of Antiquity: The Jantar Mantar',
      category: 'Science',
      description: '',
      readTime: '5 min left',
      progressPercent: 80,
      lastRead: 'Last read 2 days ago',
    ),
  ];
});

final todayDiscoveriesProvider = Provider<List<HomeDiscoveryCard>>((ref) {
  return const [
    HomeDiscoveryCard(
      category: 'History',
      readTime: '15 min read',
      title: 'Carved from the Earth: The Monolithic Temples of Ellora',
      description:
          'Explore the immense dedication and unparalleled engineering behind one of the largest rock-cut monastery-temple cave complexes in the world, a testament to ancient Indian artistry.',
      author: 'Dr. Vikram Singh',
    ),
    HomeDiscoveryCard(
      category: 'Culture',
      readTime: '8 min read',
      title: 'Threads of Time: The Indigo Heritage',
      description:
          'Delve into the complex history of indigo dyeing in India, from its ancient origins to its impact on global trade and the artisans who preserve the craft today.',
      author: 'Anjali Desai',
    ),
  ];
});

final curatedCollectionsProvider = Provider<List<HomeCuratedCollection>>((ref) {
  return const [
    HomeCuratedCollection(title: 'Mughal Architecture'),
    HomeCuratedCollection(title: 'Ancient Sciences'),
    HomeCuratedCollection(title: 'Textile Heritage'),
    HomeCuratedCollection(title: 'The Spice Routes'),
  ];
});
