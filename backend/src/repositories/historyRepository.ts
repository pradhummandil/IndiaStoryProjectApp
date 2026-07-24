import { prisma } from "../prisma/prismaClient";
import { StoryStatus } from "@prisma/client";

function toPositiveInt(value: unknown, fallback: number, max: number): number {
  const n = typeof value === "string" ? Number(value) : Number(value);
  if (!Number.isFinite(n)) return fallback;
  const i = Math.floor(n);
  if (i <= 0) return fallback;
  return Math.min(i, max);
}

export const historyRepository = {
  async getHistory(
    userId: string,
    params: {
      page?: string;
      limit?: string;
      filter?: string; // today, week, month, all
      search?: string;
    },
  ) {
    const page = toPositiveInt(params.page, 1, 1000);
    const limit = toPositiveInt(params.limit, 20, 50);
    const skip = (page - 1) * limit;

    const where: any = {
      userId,
      Story: { deleted: false, status: StoryStatus.Published },
    };

    // Date filter
    if (params.filter && params.filter !== "all") {
      const now = new Date();
      let startDate: Date;
      switch (params.filter) {
        case "today":
          startDate = new Date(
            now.getFullYear(),
            now.getMonth(),
            now.getDate(),
          );
          break;
        case "week":
          startDate = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
          break;
        case "month":
          startDate = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
          break;
        default:
          startDate = new Date(0);
      }
      where.lastReadAt = { gte: startDate };
    }

    // Search within story title
    if (params.search) {
      const q = params.search.trim();
      where.Story = {
        ...where.Story,
        title: { contains: q, mode: "insensitive" },
      };
    }

    const [items, total] = await Promise.all([
      prisma.readingProgress.findMany({
        where,
        skip,
        take: limit,
        orderBy: { lastReadAt: "desc" },
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
              Author: { select: { id: true, name: true, avatar: true } },
              StoryImage: {
                take: 1,
                orderBy: { sortOrder: "asc" },
                select: { imageUrl: true },
              },
              StoryTag: {
                take: 3,
                select: {
                  Tag: { select: { id: true, slug: true, name: true } },
                },
              },
              StoryTheme: {
                take: 3,
                select: {
                  Theme: { select: { id: true, slug: true, name: true } },
                },
              },
            },
          },
        },
      }),
      prisma.readingProgress.count({ where }),
    ]);

    // Map to response
    const historyItems = items.map((rp) => {
      const story = rp.Story as any;
      const tags = story.StoryTag?.map((x: any) => x.Tag) ?? [];
      const themes = story.StoryTheme?.map((x: any) => x.Theme) ?? [];
      return {
        id: rp.id,
        storyId: rp.storyId,
        progressPercent: rp.progressPercent,
        completed: rp.completed,
        lastReadAt: rp.lastReadAt,
        story: {
          id: story.id,
          slug: story.slug,
          title: story.title,
          excerpt: story.excerpt,
          readingTime: story.readingTime,
          viewCount: story.viewCount,
          publishedAt: story.publishedAt,
          imageUrl: story.StoryImage?.[0]?.imageUrl ?? null,
          author: story.Author,
          tags,
          themes,
          category:
            tags.length > 0
              ? tags[0].name
              : themes.length > 0
                ? themes[0].name
                : "Heritage",
        },
      };
    });

    return { page, limit, total, items: historyItems };
  },

  async deleteHistoryItem(userId: string, storyId: string) {
    await prisma.readingProgress.deleteMany({
      where: { userId, storyId },
    });
    return { success: true };
  },

  async clearHistory(userId: string) {
    await prisma.readingProgress.deleteMany({
      where: { userId },
    });
    return { success: true };
  },
};
