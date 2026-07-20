import { searchRepository } from "../../repositories/searchRepository";
import { storiesRepository } from "../../repositories/storiesRepository";
import { BadRequestError } from "../../core/errors/apiErrors";

export const searchController = {
  async getSearch(req: any) {
    const { q, category, region, sort, page, limit } = req.query ?? {};
    const userId: string | undefined =
      req.user?.id ?? req.headers["x-user-id"] ?? undefined;
    const query = String(q ?? "").trim();

    // Save search to history if authenticated and query is non-empty
    if (query && userId) {
      await searchRepository.saveSearch(userId, query).catch(() => {});
    }

    // Fetch stories using existing storiesRepository
    const stories = await storiesRepository.getStories({
      page,
      limit,
      category,
      region,
      search: query,
      sort,
    });

    // Also fetch trending and recent searches
    const [trending, recentSearches, suggestions] = await Promise.all([
      searchRepository.getTrendingSearches(),
      searchRepository.getRecentSearches(userId ?? null),
      query ? searchRepository.getSuggestions(query) : Promise.resolve([]),
    ]);

    return {
      stories,
      trending,
      recentSearches,
      suggestions,
    };
  },

  async getSuggestions(req: any) {
    const q = String(req.query?.q ?? "").trim();
    if (!q || q.length < 2) return [];
    return searchRepository.getSuggestions(q);
  },

  async getTrending(req: any) {
    return searchRepository.getTrendingSearches();
  },

  async getRecentSearches(req: any) {
    const userId: string | undefined =
      req.user?.id ?? req.headers["x-user-id"] ?? undefined;
    if (!userId) return [];
    return searchRepository.getRecentSearches(userId);
  },

  async deleteSearch(req: any) {
    const userId: string | undefined =
      req.user?.id ?? req.headers["x-user-id"] ?? undefined;
    const searchId = String(req.params?.searchId ?? "");
    if (!userId) throw new BadRequestError("Unauthorized");
    if (!searchId) throw new BadRequestError("searchId is required");
    await searchRepository.deleteSearch(userId, searchId);
    return { success: true };
  },

  async clearSearchHistory(req: any) {
    const userId: string | undefined =
      req.user?.id ?? req.headers["x-user-id"] ?? undefined;
    if (!userId) throw new BadRequestError("Unauthorized");
    await searchRepository.clearSearchHistory(userId);
    return { success: true };
  },
};
