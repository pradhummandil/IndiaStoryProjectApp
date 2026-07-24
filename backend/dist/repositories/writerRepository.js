"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.writerRepository = void 0;
const prismaClient_1 = require("../prisma/prismaClient");
const client_1 = require("@prisma/client");
exports.writerRepository = {
    async getDashboardStats(userId) {
        const userProfile = await prismaClient_1.prisma.userProfile.findUnique({
            where: { id: userId },
            select: { id: true, name: true },
        });
        // Find Author by matching name with UserProfile name
        let authorId = null;
        if (userProfile?.name) {
            const matchedAuthor = await prismaClient_1.prisma.author.findFirst({
                where: { name: userProfile.name },
                select: { id: true },
            });
            if (matchedAuthor) {
                authorId = matchedAuthor.id;
            }
        }
        if (!authorId) {
            // Return empty stats if no author match
            return {
                stats: {
                    totalReads: 0,
                    avgReadingTime: 0,
                    totalViews: 0,
                    totalLikes: 0,
                    totalBookmarks: 0,
                    totalReadingTime: 0,
                    completionRate: 0,
                    draftCount: 0,
                    publishedCount: 0,
                },
                drafts: [],
                published: [],
                recentStories: [],
                analytics: {
                    viewsToday: 0,
                    viewsThisWeek: 0,
                    viewsThisMonth: 0,
                    likesToday: 0,
                    likesThisWeek: 0,
                    likesThisMonth: 0,
                },
                achievements: {
                    totalStories: 0,
                    totalViews: 0,
                    totalLikes: 0,
                    totalReadingTime: 0,
                    level: 1,
                    xp: 0,
                    xpNext: 100,
                },
            };
        }
        // All stories by this author
        const allStories = await prismaClient_1.prisma.story.findMany({
            where: {
                authorId: authorId,
                deleted: false,
            },
            orderBy: { updatedAt: "desc" },
            include: {
                StoryImage: {
                    take: 1,
                    orderBy: { sortOrder: "asc" },
                    select: { imageUrl: true },
                },
                StoryLike: { select: { id: true } },
                Bookmark: { select: { id: true } },
                ReadingProgress: {
                    select: { progressPercent: true, completed: true },
                },
                Author: { select: { id: true, name: true, avatar: true } },
            },
        });
        const draftStories = allStories.filter((s) => s.status === client_1.StoryStatus.Draft);
        const publishedStories = allStories.filter((s) => s.status === client_1.StoryStatus.Published);
        // Compute stats
        const totalViews = allStories.reduce((sum, s) => sum + s.viewCount, 0);
        const totalLikes = allStories.reduce((sum, s) => sum + s.StoryLike.length, 0);
        const totalBookmarks = allStories.reduce((sum, s) => sum + s.Bookmark.length, 0);
        const readingProgressEntries = allStories.flatMap((s) => s.ReadingProgress);
        const completedReads = readingProgressEntries.filter((rp) => rp.completed).length;
        const completionRate = readingProgressEntries.length > 0
            ? Math.round((completedReads / readingProgressEntries.length) * 100)
            : 0;
        const avgReadingTime = publishedStories.length > 0
            ? Math.round(publishedStories.reduce((sum, s) => sum + (s.readingTime || 0), 0) /
                publishedStories.length)
            : 0;
        const totalReadingTime = allStories.reduce((sum, s) => sum + (s.readingTime || 0) * s.viewCount, 0);
        // Map to response format
        const mapStory = (s) => ({
            id: s.id,
            slug: s.slug,
            title: s.title,
            excerpt: s.excerpt,
            status: s.status,
            readingTime: s.readingTime,
            viewCount: s.viewCount,
            publishedAt: s.publishedAt,
            updatedAt: s.updatedAt,
            imageUrl: s.StoryImage?.[0]?.imageUrl ?? null,
            author: s.Author,
            likesCount: s.StoryLike.length,
            bookmarksCount: s.Bookmark.length,
        });
        const recentStories = allStories.slice(0, 5).map(mapStory);
        // Analytics (time-based)
        const now = new Date();
        const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const startOfWeek = new Date(startOfDay);
        startOfWeek.setDate(startOfWeek.getDate() - startOfWeek.getDay());
        const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
        // Get story IDs for this author
        const storyIds = allStories.map((s) => s.id);
        const pageViews = await prismaClient_1.prisma.pageView.findMany({
            where: {
                storyId: { in: storyIds },
            },
            select: { createdAt: true },
        });
        const viewsToday = pageViews.filter((pv) => pv.createdAt >= startOfDay).length;
        const viewsThisWeek = pageViews.filter((pv) => pv.createdAt >= startOfWeek).length;
        const viewsThisMonth = pageViews.filter((pv) => pv.createdAt >= startOfMonth).length;
        const storyLikes = await prismaClient_1.prisma.storyLike.findMany({
            where: {
                storyId: { in: storyIds },
            },
            select: { createdAt: true },
        });
        const likesToday = storyLikes.filter((sl) => sl.createdAt >= startOfDay).length;
        const likesThisWeek = storyLikes.filter((sl) => sl.createdAt >= startOfWeek).length;
        const likesThisMonth = storyLikes.filter((sl) => sl.createdAt >= startOfMonth).length;
        // Achievements / XP
        const totalStories = allStories.length;
        const xp = totalStories * 10 + totalLikes * 2 + totalBookmarks * 3 + totalViews;
        const level = Math.floor(xp / 100) + 1;
        const xpNext = level * 100;
        return {
            stats: {
                totalReads: totalViews,
                avgReadingTime,
                totalViews,
                totalLikes,
                totalBookmarks,
                totalReadingTime,
                completionRate,
                draftCount: draftStories.length,
                publishedCount: publishedStories.length,
            },
            drafts: draftStories.slice(0, 10).map(mapStory),
            published: publishedStories.slice(0, 10).map(mapStory),
            recentStories,
            analytics: {
                viewsToday,
                viewsThisWeek,
                viewsThisMonth,
                likesToday,
                likesThisWeek,
                likesThisMonth,
            },
            achievements: {
                totalStories,
                totalViews,
                totalLikes,
                totalReadingTime,
                level,
                xp,
                xpNext,
            },
        };
    },
    async getWriterStories(userId) {
        const userProfile = await prismaClient_1.prisma.userProfile.findUnique({
            where: { id: userId },
            select: { name: true },
        });
        let authorId = null;
        if (userProfile?.name) {
            const matchedAuthor = await prismaClient_1.prisma.author.findFirst({
                where: { name: userProfile.name },
                select: { id: true },
            });
            if (matchedAuthor) {
                authorId = matchedAuthor.id;
            }
        }
        if (!authorId)
            return [];
        const stories = await prismaClient_1.prisma.story.findMany({
            where: { authorId, deleted: false },
            orderBy: { updatedAt: "desc" },
            include: {
                StoryImage: {
                    take: 1,
                    orderBy: { sortOrder: "asc" },
                    select: { imageUrl: true },
                },
                StoryLike: { select: { id: true } },
                Bookmark: { select: { id: true } },
                Author: { select: { id: true, name: true, avatar: true } },
            },
        });
        return stories.map((s) => ({
            id: s.id,
            slug: s.slug,
            title: s.title,
            excerpt: s.excerpt,
            status: s.status,
            readingTime: s.readingTime,
            viewCount: s.viewCount,
            publishedAt: s.publishedAt,
            updatedAt: s.updatedAt,
            imageUrl: s.StoryImage?.[0]?.imageUrl ?? null,
            author: s.Author,
            likesCount: s.StoryLike.length,
            bookmarksCount: s.Bookmark.length,
        }));
    },
    async getWriterStoryById(userId, storyId) {
        const userProfile = await prismaClient_1.prisma.userProfile.findUnique({
            where: { id: userId },
            select: { name: true },
        });
        let authorId = null;
        if (userProfile?.name) {
            const matchedAuthor = await prismaClient_1.prisma.author.findFirst({
                where: { name: userProfile.name },
                select: { id: true },
            });
            if (matchedAuthor) {
                authorId = matchedAuthor.id;
            }
        }
        if (!authorId)
            return null;
        const story = await prismaClient_1.prisma.story.findFirst({
            where: { id: storyId, authorId, deleted: false },
            include: {
                Author: { select: { id: true, name: true, avatar: true, bio: true } },
                StoryImage: {
                    orderBy: { sortOrder: "asc" },
                    select: { imageUrl: true, sortOrder: true, caption: true },
                },
                StoryTag: { include: { Tag: true } },
                StoryTheme: { include: { Theme: true } },
                StoryLike: { select: { id: true, userId: true, createdAt: true } },
                Bookmark: { select: { id: true, userId: true, createdAt: true } },
                ReadingProgress: {
                    select: { progressPercent: true, completed: true },
                },
                Comment: {
                    take: 20,
                    orderBy: { createdAt: "desc" },
                    select: {
                        id: true,
                        content: true,
                        userId: true,
                        createdAt: true,
                    },
                },
            },
        });
        if (!story)
            return null;
        return {
            ...story,
            likesCount: story.StoryLike.length,
            bookmarksCount: story.Bookmark.length,
            readingProgressCount: story.ReadingProgress.length,
            commentsCount: story.Comment.length,
        };
    },
};
