"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.searchController = void 0;
const searchRepository_1 = require("../../repositories/searchRepository");
const storiesRepository_1 = require("../../repositories/storiesRepository");
const apiErrors_1 = require("../../core/errors/apiErrors");
exports.searchController = {
    async getSearch(req) {
        const { q, category, region, sort, page, limit } = req.query ?? {};
        const userId = req.user?.id ?? req.headers["x-user-id"] ?? undefined;
        const query = String(q ?? "").trim();
        // Save search to history if authenticated and query is non-empty
        if (query && userId) {
            await searchRepository_1.searchRepository.saveSearch(userId, query).catch(() => { });
        }
        // Fetch stories using existing storiesRepository
        const stories = await storiesRepository_1.storiesRepository.getStories({
            page,
            limit,
            category,
            region,
            search: query,
            sort,
        });
        // Also fetch trending and recent searches
        const [trending, recentSearches, suggestions] = await Promise.all([
            searchRepository_1.searchRepository.getTrendingSearches(),
            searchRepository_1.searchRepository.getRecentSearches(userId ?? null),
            query ? searchRepository_1.searchRepository.getSuggestions(query) : Promise.resolve([]),
        ]);
        return {
            stories,
            trending,
            recentSearches,
            suggestions,
        };
    },
    async getSuggestions(req) {
        const q = String(req.query?.q ?? "").trim();
        if (!q || q.length < 2)
            return [];
        return searchRepository_1.searchRepository.getSuggestions(q);
    },
    async getTrending(req) {
        return searchRepository_1.searchRepository.getTrendingSearches();
    },
    async getRecentSearches(req) {
        const userId = req.user?.id ?? req.headers["x-user-id"] ?? undefined;
        if (!userId)
            return [];
        return searchRepository_1.searchRepository.getRecentSearches(userId);
    },
    async deleteSearch(req) {
        const userId = req.user?.id ?? req.headers["x-user-id"] ?? undefined;
        const searchId = String(req.params?.searchId ?? "");
        if (!userId)
            throw new apiErrors_1.BadRequestError("Unauthorized");
        if (!searchId)
            throw new apiErrors_1.BadRequestError("searchId is required");
        await searchRepository_1.searchRepository.deleteSearch(userId, searchId);
        return { success: true };
    },
    async clearSearchHistory(req) {
        const userId = req.user?.id ?? req.headers["x-user-id"] ?? undefined;
        if (!userId)
            throw new apiErrors_1.BadRequestError("Unauthorized");
        await searchRepository_1.searchRepository.clearSearchHistory(userId);
        return { success: true };
    },
};
