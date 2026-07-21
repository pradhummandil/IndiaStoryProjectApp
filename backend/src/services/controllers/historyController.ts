import { historyRepository } from "../../repositories/historyRepository";
import { BadRequestError } from "../../core/errors/apiErrors";

export const historyController = {
  async getHistory(req: any) {
    const userId: string | undefined =
      req.user?.id ?? req.headers["x-user-id"] ?? undefined;
    if (!userId) throw new BadRequestError("Unauthorized");

    const { page, limit, filter, search } = req.query ?? {};
    return historyRepository.getHistory(userId, {
      page,
      limit,
      filter,
      search,
    });
  },

  async deleteHistoryItem(req: any) {
    const userId: string | undefined =
      req.user?.id ?? req.headers["x-user-id"] ?? undefined;
    if (!userId) throw new BadRequestError("Unauthorized");

    const storyId = String(req.params?.storyId ?? "");
    if (!storyId) throw new BadRequestError("storyId is required");

    return historyRepository.deleteHistoryItem(userId, storyId);
  },

  async clearHistory(req: any) {
    const userId: string | undefined =
      req.user?.id ?? req.headers["x-user-id"] ?? undefined;
    if (!userId) throw new BadRequestError("Unauthorized");

    return historyRepository.clearHistory(userId);
  },
};
