"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.searchRepository = void 0;
const crypto_1 = __importDefault(require("crypto"));
const prismaClient_1 = require("../prisma/prismaClient");
const client_1 = require("@prisma/client");
exports.searchRepository = {
    async getRecentSearches(userId) {
        if (!userId)
            return [];
        const items = await prismaClient_1.prisma.searchHistory.findMany({
            where: { userId },
            orderBy: { createdAt: "desc" },
            take: 10,
            select: { id: true, query: true, createdAt: true },
        });
        return items;
    },
    async saveSearch(userId, query) {
        // Upsert: if the same query exists, update createdAt to push it to top
        const existing = await prismaClient_1.prisma.searchHistory.findFirst({
            where: { userId, query: { equals: query, mode: "insensitive" } },
        });
        if (existing) {
            await prismaClient_1.prisma.searchHistory.update({
                where: { id: existing.id },
                data: { createdAt: new Date() },
            });
        }
        else {
            // Keep only 20 per user; delete oldest if exceeded
            const count = await prismaClient_1.prisma.searchHistory.count({ where: { userId } });
            if (count >= 20) {
                const oldest = await prismaClient_1.prisma.searchHistory.findFirst({
                    where: { userId },
                    orderBy: { createdAt: "asc" },
                    select: { id: true },
                });
                if (oldest) {
                    await prismaClient_1.prisma.searchHistory.delete({ where: { id: oldest.id } });
                }
            }
            await prismaClient_1.prisma.searchHistory.create({
                data: { id: crypto_1.default.randomUUID(), userId, query },
            });
        }
        // Track trending
        const tracker = await prismaClient_1.prisma.searchQueryTracker.findUnique({
            where: { query },
        });
        if (tracker) {
            await prismaClient_1.prisma.searchQueryTracker.update({
                where: { query },
                data: { count: tracker.count + 1, updatedAt: new Date() },
            });
        }
        else {
            await prismaClient_1.prisma.searchQueryTracker.create({
                data: {
                    id: crypto_1.default.randomUUID(),
                    query,
                    count: 1,
                    updatedAt: new Date(),
                },
            });
        }
    },
    async deleteSearch(userId, searchId) {
        await prismaClient_1.prisma.searchHistory.deleteMany({
            where: { id: searchId, userId },
        });
    },
    async clearSearchHistory(userId) {
        await prismaClient_1.prisma.searchHistory.deleteMany({ where: { userId } });
    },
    async getTrendingSearches() {
        const items = await prismaClient_1.prisma.searchQueryTracker.findMany({
            orderBy: { count: "desc" },
            take: 10,
            select: { id: true, query: true, count: true },
        });
        return items;
    },
    async getSuggestions(query) {
        if (!query || query.trim().length < 2)
            return [];
        const items = await prismaClient_1.prisma.searchQueryTracker.findMany({
            where: { query: { contains: query.trim(), mode: "insensitive" } },
            orderBy: { count: "desc" },
            take: 8,
            select: { query: true, count: true },
        });
        // Also add matching story titles
        const stories = await prismaClient_1.prisma.story.findMany({
            where: {
                deleted: false,
                status: client_1.StoryStatus.Published,
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
