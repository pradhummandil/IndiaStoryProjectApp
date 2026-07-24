"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.homeRepository = void 0;
const prismaClient_1 = require("../prisma/prismaClient");
const client_1 = require("@prisma/client");
function parseIntOrUndef(value) {
    if (value === undefined || value === null)
        return undefined;
    const n = Number(value);
    return Number.isFinite(n) ? n : undefined;
}
exports.homeRepository = {
    async getHome() {
        // featuredStory: FeaturedStory join Story (published & not deleted)
        const featured = await prismaClient_1.prisma.featuredStory.findMany({
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
                    },
                },
            },
        });
        const featuredStory = featured[0]?.Story ?? null;
        // latestStories
        const latestStories = await prismaClient_1.prisma.story.findMany({
            where: { deleted: false, status: client_1.StoryStatus.Published },
            orderBy: { publishedAt: "desc" },
            take: 10,
            include: {
                Author: { select: { id: true, name: true, avatar: true } },
            },
        });
        // continueReading (based on last ReadingProgress)
        const readingProgress = await prismaClient_1.prisma.readingProgress.findMany({
            where: {
                completed: false,
                Story: { deleted: false, status: client_1.StoryStatus.Published },
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
        const trendingStories = await prismaClient_1.prisma.story.findMany({
            where: {
                deleted: false,
                status: client_1.StoryStatus.Published,
                trendingStory: true,
            },
            orderBy: [{ updatedAt: "desc" }, { viewCount: "desc" }],
            take: 10,
            include: {
                Author: { select: { id: true, name: true, avatar: true } },
            },
        });
        // categories: use Tag (as content categories) fallback
        const categories = await prismaClient_1.prisma.tag.findMany({
            take: 50,
            orderBy: { createdAt: "desc" },
            select: { id: true, name: true, slug: true },
        });
        // collections
        const collections = await prismaClient_1.prisma.collection.findMany({
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
