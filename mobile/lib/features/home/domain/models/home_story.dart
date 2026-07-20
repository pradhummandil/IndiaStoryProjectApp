class HomeStory {
  const HomeStory({
    required this.title,
    required this.category,
    required this.description,
    required this.readTime,
    required this.progressPercent,
    required this.lastRead,
    this.imageUrl,
  });

  final String title;
  final String category;
  final String description;
  final String readTime;
  final int progressPercent;
  final String lastRead;
  final String? imageUrl;
}

class HomeReadingStreak {
  const HomeReadingStreak({
    required this.days,
    required this.level,
    required this.xp,
    required this.xpMax,
    required this.message,
    required this.progressPercent,
  });

  final int days;
  final String level;
  final int xp;
  final int xpMax;
  final String message;
  final double progressPercent;
}

class HomeDiscoveryCard {
  const HomeDiscoveryCard({
    required this.category,
    required this.readTime,
    required this.title,
    required this.description,
    required this.author,
    this.imageUrl,
  });

  final String category;
  final String readTime;
  final String title;
  final String description;
  final String author;
  final String? imageUrl;
}

class HomeCuratedCollection {
  const HomeCuratedCollection({required this.title});

  final String title;
}
