"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.bookmarksRepository = void 0;
const crypto_1 = __importDefault(require("crypto"));
const prismaClient_1 = require("../prisma/prismaClient");
exports.bookmarksRepository = {
    async getBookmarks(userId) {
        const bookmarks = await prismaClient_1.prisma.bookmark.findMany({
            where: { userId },
            orderBy: { createdAt: "desc" },
            include: {
                Story: {
                    include: {
                        Author: { select: { id: true, name: true, avatar: true } },
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
                    tags: b.Story.StoryTag?.map((x) => x.Tag) ?? [],
                    themes: b.Story.StoryTheme?.map((x) => x.Theme) ?? [],
                },
            })),
        };
    },
    async addBookmark(userId, storyId) {
        const existing = await prismaClient_1.prisma.bookmark.findUnique({
            where: { userId_storyId: { userId, storyId } },
        });
        if (existing)
            return existing;
        return prismaClient_1.prisma.bookmark.create({
            data: { id: crypto_1.default.randomUUID(), userId, storyId },
        });
    },
    async removeBookmark(userId, storyId) {
        const existing = await prismaClient_1.prisma.bookmark.findUnique({
            where: { userId_storyId: { userId, storyId } },
        });
        if (!existing)
            return null;
        return prismaClient_1.prisma.bookmark.delete({
            where: { userId_storyId: { userId, storyId } },
        });
    },
};
