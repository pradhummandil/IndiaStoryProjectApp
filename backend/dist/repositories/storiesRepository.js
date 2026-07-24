"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.storiesRepository = void 0;
const prismaClient_1 = require("../prisma/prismaClient");
const client_1 = require("@prisma/client");
function toPositiveInt(value, fallback, max) {
    const n = typeof value === "string" ? Number(value) : Number(value);
    if (!Number.isFinite(n))
        return fallback;
    const i = Math.floor(n);
    if (i <= 0)
        return fallback;
    return Math.min(i, max);
}
exports.storiesRepository = {
    async getStories(params) {
        const page = toPositiveInt(params.page, 1, 1000);
        const limit = toPositiveInt(params.limit, 10, 50);
        const skip = (page - 1) * limit;
        const where = {
            deleted: false,
            status: client_1.StoryStatus.Published,
        };
        // category -> interpret as Tag.slug or Theme.slug.
        if (params.category) {
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
        const orderBy = sort === "trending"
            ? { trendingStory: "desc" }
            : sort === "popular"
                ? { viewCount: "desc" }
                : sort === "new"
                    ? { publishedAt: "desc" }
                    : { publishedAt: "desc" };
        const [items, total] = await Promise.all([
            prismaClient_1.prisma.story.findMany({
                where,
                skip,
                take: limit,
                orderBy,
                include: {
                    Author: { select: { id: true, name: true, avatar: true } },
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
            prismaClient_1.prisma.story.count({ where }),
        ]);
        return {
            page,
            limit,
            total,
            items: items.map((s) => ({
                id: s.id,
                slug: s.slug,
                title: s.title,
                excerpt: s.excerpt,
                readingTime: s.readingTime,
                viewCount: s.viewCount,
                publishedAt: s.publishedAt,
                author: s.Author,
                imageUrl: s.StoryImage?.[0]?.imageUrl ?? null,
                tags: s.StoryTag?.map((x) => x.Tag) ?? [],
                themes: s.StoryTheme?.map((x) => x.Theme) ?? [],
            })),
        };
    },
    async getStoryBySlug(slug) {
        const story = await prismaClient_1.prisma.story.findUnique({
            where: { slug },
            include: {
                Author: {
                    select: { id: true, name: true, bio: true, avatar: true },
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
        if (!story || story.deleted || story.status !== client_1.StoryStatus.Published) {
            return null;
        }
        // reading statistics (best-effort from persisted counters)
        const readingStats = {
            viewCount: story.viewCount,
            bookmarkCount: await prismaClient_1.prisma.bookmark.count({
                where: { storyId: story.id },
            }),
            likesCount: await prismaClient_1.prisma.storyLike.count({
                where: { storyId: story.id },
            }),
            readingProgressCount: await prismaClient_1.prisma.readingProgress.count({
                where: { storyId: story.id },
            }),
        };
        // related stories by shared tags or themes
        const tagIds = story.StoryTag.map((x) => x.tagId);
        const themeIds = story.StoryTheme.map((x) => x.themeId);
        const orConditions = [];
        if (tagIds.length) {
            orConditions.push({ StoryTag: { some: { tagId: { in: tagIds } } } });
        }
        if (themeIds.length) {
            orConditions.push({
                StoryTheme: { some: { themeId: { in: themeIds } } },
            });
        }
        const relatedWhere = {
            id: { not: story.id },
            deleted: false,
            status: client_1.StoryStatus.Published,
        };
        if (orConditions.length > 0) {
            relatedWhere.OR = orConditions;
        }
        const relatedStories = await prismaClient_1.prisma.story.findMany({
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
                Author: { select: { id: true, name: true, avatar: true } },
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
                tags: story.StoryTag.map((x) => x.Tag),
                themes: story.StoryTheme.map((x) => x.Theme),
            },
            author: story.Author,
            category: { state: story.State, city: story.City },
            relatedStories,
            readingStatistics: readingStats,
        };
    },
};
