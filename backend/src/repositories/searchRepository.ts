import { prisma } from "../prisma/prismaClient";

export const searchRepository = {
  async getRecentSearches(userId: string | null) {
    if (!userId) return [];
    const items = await prisma.searchHistory.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
      take: 10,
      select: { id: true, query: true, createdAt: true },
    });
    return items;
  },

  async saveSearch(userId: string, query: string) {
    // Upsert: if the same query exists, update createdAt to push it to top
    const existing = await prisma.searchHistory.findFirst({
      where: { userId, query: { equals: query, mode: "insensitive" } },
    });
    if (existing) {
      await prisma.searchHistory.update({
        where: { id: existing.id },
        data: { createdAt: new Date() },
      });
    } else {
      // Keep only 20 per user; delete oldest if exceeded
      const count = await prisma.searchHistory.count({ where: { userId } });
      if (count >= 20) {
        const oldest = await prisma.searchHistory.findFirst({
          where: { userId },
          orderBy: { createdAt: "asc" },
          select: { id: true },
        });
        if (oldest) {
          await prisma.searchHistory.delete({ where: { id: oldest.id } });
        }
      }
      await prisma.searchHistory.create({
        data: { id: crypto.randomUUID(), userId, query },
      });
    }

    // Track trending
    const tracker = await prisma.searchQueryTracker.findUnique({
      where: { query },
    });
    if (tracker) {
      await prisma.searchQueryTracker.update({
        where: { query },
        data: { count: tracker.count + 1, updatedAt: new Date() },
      });
    } else {
      await prisma.searchQueryTracker.create({
        data: { id: crypto.randomUUID(), query, count: 1 },
      });
    }
  },

  async deleteSearch(userId: string, searchId: string) {
    await prisma.searchHistory.deleteMany({
      where: { id: searchId, userId },
    });
  },

  async clearSearchHistory(userId: string) {
    await prisma.searchHistory.deleteMany({ where: { userId } });
  },

  async getTrendingSearches() {
    const items = await prisma.searchQueryTracker.findMany({
      orderBy: { count: "desc" },
      take: 10,
      select: { id: true, query: true, count: true },
    });
    return items;
  },

  async getSuggestions(query: string) {
    if (!query || query.trim().length < 2) return [];
    const items = await prisma.searchQueryTracker.findMany({
      where: { query: { contains: query.trim(), mode: "insensitive" } },
      orderBy: { count: "desc" },
      take: 8,
      select: { query: true, count: true },
    });
    // Also add matching story titles
    const stories = await prisma.story.findMany({
      where: {
        deleted: false,
        status: "Published" as any,
        title: { contains: query.trim(), mode: "insensitive" },
      },
      orderBy: { viewCount: "desc" },
      take: 4,
      select: { title: true },
    });
    const storyTitles = stories.map((s) => s.title);
    const suggestionSet = new Set([
      ...items.map((i) => i.query),
      ...storyTitles,
    ]);
    return Array.from(suggestionSet).slice(0, 10);
  },
};
