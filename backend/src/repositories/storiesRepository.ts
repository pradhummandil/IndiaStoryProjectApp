import { prisma } from "../prisma/prismaClient";

type GetStoriesParams = {
  page?: string;
  limit?: string;
  category?: string;
  region?: string;
  language?: string;
  search?: string;
  sort?: string;
};

function toPositiveInt(value: unknown, fallback: number, max: number): number {
  const n = typeof value === "string" ? Number(value) : Number(value);
  if (!Number.isFinite(n)) return fallback;
  const i = Math.floor(n);
  if (i <= 0) return fallback;
  return Math.min(i, max);
}

export const storiesRepository = {
  async getStories(params: GetStoriesParams) {
    const page = toPositiveInt(params.page, 1, 1000);
    const limit = toPositiveInt(params.limit, 10, 50);
    const skip = (page - 1) * limit;

    const where: any = {
      deleted: false,
      status: "Published" as any,
    };

    // category -> interpret as Tag.slug or Theme.slug.
    if (params.category) {
      // prefer Tag.slug
      where.OR = [
        {
          StoryTag: { some: { Tag: { slug: params.category } } },
        },
        {
          StoryTheme: { some: { Theme: { slug: params.category } } },
        },
      ];
    }

    // region -> interpret as State.slug or City.slug
    if (params.region) {
      where.OR = [
        { State: { slug: params.region } },
        { City: { slug: params.region } },
      ];
    }

    // language -> we don't have language column on Story; use excerptHi/contentHi selection in controller layer.
    // Keep filter no-op for now.

    // search -> title/excerpt/seoTitle
    if (params.search) {
      const q = params.search.trim();
      where.OR = [
        { title: { contains: q, mode: "insensitive" } },
        { excerpt: { contains: q, mode: "insensitive" } },
        { seoTitle: { contains: q, mode: "insensitive" } },
        { seoDescription: { contains: q, mode: "insensitive" } },
      ];
    }

    // sorting
    const sort = params.sort?.toLowerCase();
    const orderBy: any =
      sort === "trending"
        ? { trendingStory: "desc" }
        : sort === "popular"
          ? { viewCount: "desc" }
          : sort === "new"
            ? { publishedAt: "desc" }
            : { publishedAt: "desc" };

    const [items, total] = await Promise.all([
      prisma.story.findMany({
        where,
        skip,
        take: limit,
        orderBy,
        include: {
          Author: { select: { id: true, name: true, avatar: true } as any },
          StoryImage: {
            take: 1,
            orderBy: { sortOrder: "asc" },
            select: { imageUrl: true },
          },
          StoryTag: {
            take: 10,
            select: { Tag: { select: { id: true, slug: true, name: true } } },
          },
          StoryTheme: {
            take: 10,
            select: { Theme: { select: { id: true, slug: true, name: true } } },
          },
        },
      }),
      prisma.story.count({ where }),
    ]);

    return {
      page,
      limit,
      total,
      items: items.map((s: any) => ({
        id: s.id,
        slug: s.slug,
        title: s.title,
        excerpt: s.excerpt,
        readingTime: s.readingTime,
        viewCount: s.viewCount,
        publishedAt: s.publishedAt,
        author: s.Author,
        imageUrl: s.StoryImage?.[0]?.imageUrl ?? null,
        tags: s.StoryTag?.map((x: any) => x.Tag) ?? [],
        themes: s.StoryTheme?.map((x: any) => x.Theme) ?? [],
      })),
    };
  },

  async getStoryBySlug(slug: string) {
    const story = await prisma.story.findUnique({
      where: { slug },
      include: {
        Author: {
          select: { id: true, name: true, bio: true, avatar: true } as any,
        },
        State: { select: { slug: true, name: true } },
        City: { select: { slug: true, name: true } },
        StoryTag: { include: { Tag: true } },
        StoryTheme: { include: { Theme: true } },
        StoryImage: {
          take: 5,
          orderBy: { sortOrder: "asc" },
          select: { imageUrl: true, sortOrder: true, caption: true },
        },
        ReadingProgress: {
          take: 20,
          orderBy: { lastReadAt: "desc" },
          select: { progressPercent: true, completed: true, lastReadAt: true },
        },
        StoryView: { take: 1, select: { createdAt: true } },
      },
    });

    if (!story || story.deleted || story.status !== ("Published" as any)) {
      return null;
    }

    // reading statistics (best-effort from persisted counters)
    const readingStats = {
      viewCount: story.viewCount,
      bookmarkCount: await prisma.bookmark.count({
        where: { storyId: story.id },
      }),
      likesCount: await prisma.storyLike.count({
        where: { storyId: story.id },
      }),
      readingProgressCount: await prisma.readingProgress.count({
        where: { storyId: story.id },
      }),
    };

    // related stories by shared tags or themes
    const tagIds = story.StoryTag.map((x: any) => x.tagId);
    const themeIds = story.StoryTheme.map((x: any) => x.themeId);

    const orConditions: any[] = [];
    if (tagIds.length) {
      orConditions.push({ StoryTag: { some: { tagId: { in: tagIds } } } });
    }
    if (themeIds.length) {
      orConditions.push({
        StoryTheme: { some: { themeId: { in: themeIds } } },
      });
    }

    const relatedWhere: any = {
      id: { not: story.id },
      deleted: false,
      status: "Published" as any,
    };
    if (orConditions.length > 0) {
      relatedWhere.OR = orConditions;
    }

    const relatedStories = await prisma.story.findMany({
      where: relatedWhere,
      take: 8,
      orderBy: { updatedAt: "desc" },
      select: {
        id: true,
        slug: true,
        title: true,
        excerpt: true,
        readingTime: true,
        viewCount: true,
        Author: { select: { id: true, name: true, avatar: true } as any },
      },
    });

    return {
      story: {
        id: story.id,
        slug: story.slug,
        title: story.title,
        excerpt: story.excerpt,
        contentHi: story.contentHi,
        titleHi: story.titleHi,
        excerptHi: story.excerptHi,
        readingTime: story.readingTime,
        publishedAt: story.publishedAt,
        seoTitle: story.seoTitle,
        seoDescription: story.seoDescription,
        seoKeywords: story.seoKeywords,
        viewCount: story.viewCount,
        images: story.StoryImage,
        tags: story.StoryTag.map((x: any) => x.Tag),
        themes: story.StoryTheme.map((x: any) => x.Theme),
      },
      author: story.Author,
      category: { state: story.State, city: story.City },
      relatedStories,
      readingStatistics: readingStats,
    };
  },
};
