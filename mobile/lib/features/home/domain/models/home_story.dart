class HomeStory {
  const HomeStory({
    required this.title,
    required this.category,
    required this.description,
    required this.readTime,
    required this.progressPercent,
    required this.lastRead,
  });

  final String title;
  final String category;
  final String description;

  final String readTime;
  final int progressPercent;
  final String lastRead;
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
  });

  final String category;
  final String readTime;
  final String title;
  final String description;
  final String author;
}

class HomeCuratedCollection {
  const HomeCuratedCollection({required this.title});

  final String title;
}
