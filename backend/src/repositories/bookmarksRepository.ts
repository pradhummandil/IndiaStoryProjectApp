import { prisma } from "../prisma/prismaClient";

export const bookmarksRepository = {
  async getBookmarks(userId: string) {
    const bookmarks = await prisma.bookmark.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
      include: {
        Story: {
          include: {
            Author: { select: { id: true, name: true, avatar: true } as any },
            StoryImage: {
              take: 1,
              orderBy: { sortOrder: "asc" },
              select: { imageUrl: true },
            },
            StoryTag: {
              take: 5,
              select: { Tag: { select: { id: true, slug: true, name: true } } },
            },
            StoryTheme: {
              take: 5,
              select: {
                Theme: { select: { id: true, slug: true, name: true } },
              },
            },
          },
        },
      },
    });

    return {
      total: bookmarks.length,
      items: bookmarks.map((b) => ({
        id: b.id,
        storyId: b.storyId,
        createdAt: b.createdAt,
        story: {
          id: b.Story.id,
          slug: b.Story.slug,
          title: b.Story.title,
          excerpt: b.Story.excerpt,
          readingTime: b.Story.readingTime,
          viewCount: b.Story.viewCount,
          publishedAt: b.Story.publishedAt,
          status: b.Story.status,
          author: b.Story.Author,
          imageUrl: b.Story.StoryImage?.[0]?.imageUrl ?? null,
          tags: b.Story.StoryTag?.map((x: any) => x.Tag) ?? [],
          themes: b.Story.StoryTheme?.map((x: any) => x.Theme) ?? [],
        },
      })),
    };
  },

  async addBookmark(userId: string, storyId: string) {
    const existing = await prisma.bookmark.findUnique({
      where: { userId_storyId: { userId, storyId } },
    });
    if (existing) return existing;

    return prisma.bookmark.create({
      data: { id: crypto.randomUUID(), userId, storyId },
    });
  },

  async removeBookmark(userId: string, storyId: string) {
    const existing = await prisma.bookmark.findUnique({
      where: { userId_storyId: { userId, storyId } },
    });
    if (!existing) return null;

    return prisma.bookmark.delete({
      where: { userId_storyId: { userId, storyId } },
    });
  },
};
