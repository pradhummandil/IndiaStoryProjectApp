import { prisma } from "../prisma/prismaClient";

function parseIntOrUndef(value: unknown): number | undefined {
  if (value === undefined || value === null) return undefined;
  const n = Number(value);
  return Number.isFinite(n) ? n : undefined;
}

export const homeRepository = {
  async getHome() {
    // featuredStory: FeaturedStory join Story (published & not deleted)
    const featured = await prisma.featuredStory.findMany({
      where: { active: true, Story: { deleted: false } },
      orderBy: [{ section: "asc" }, { sortOrder: "asc" }],
      take: 1,
      include: {
        Story: {
          select: {
            id: true,
            slug: true,
            title: true,
            excerpt: true,
            contentHi: true,
            authorId: true,
            stateId: true,
            cityId: true,
            readingTime: true,
            viewCount: true,
            updatedAt: true,
            publishedAt: true,
            featured: true,
            trendingStory: true,
            AudioProgress: false as any,
          },
        },
      },
    });

    const featuredStory = featured[0]?.Story ?? null;

    // latestStories
    const latestStories = await prisma.story.findMany({
      where: { deleted: false, status: "Published" as any },
      orderBy: { publishedAt: "desc" },
      take: 10,
      include: {
        Author: { select: { id: true, name: true, avatar: true } as any },
      },
    });

    // continueReading (based on last ReadingProgress)
    // Without auth context we return a best-effort list: last updated reading progress (limit 10)
    const readingProgress = await prisma.readingProgress.findMany({
      where: {
        completed: false,
        Story: { deleted: false, status: "Published" as any },
      },
      orderBy: { lastReadAt: "desc" },
      take: 10,
      include: {
        Story: {
          select: {
            id: true,
            slug: true,
            title: true,
            excerpt: true,
            readingTime: true,
            viewCount: true,
            publishedAt: true,
            authorId: true,
          },
        },
      },
    });

    const continueReading = readingProgress.map((rp) => ({
      progressPercent: rp.progressPercent,
      lastReadAt: rp.lastReadAt,
      completed: rp.completed,
      story: rp.Story,
    }));

    // trendingStories (trendingStory flag)
    const trendingStories = await prisma.story.findMany({
      where: {
        deleted: false,
        status: "Published" as any,
        trendingStory: true,
      },
      orderBy: [{ updatedAt: "desc" }, { viewCount: "desc" }],
      take: 10,
      include: {
        Author: { select: { id: true, name: true, avatar: true } as any },
      },
    });

    // categories: use Tag (as content categories) fallback
    const categories = await prisma.tag.findMany({
      take: 50,
      orderBy: { createdAt: "desc" },
      select: { id: true, name: true, slug: true },
    });

    // collections
    const collections = await prisma.collection.findMany({
      where: {},
      take: 20,
      orderBy: { createdAt: "desc" },
      include: {
        CollectionStory: {
          take: 6,
          include: {
            Story: {
              select: { id: true, slug: true, title: true, excerpt: true },
            },
          },
        },
      },
    });

    return {
      featuredStory,
      latestStories,
      continueReading,
      trendingStories,
      categories,
      collections: collections.map((c) => ({
        id: c.id,
        name: c.name,
        userId: c.userId,
        createdAt: c.createdAt,
        stories: c.CollectionStory.map((cs) => cs.Story),
      })),
    };
  },
};
