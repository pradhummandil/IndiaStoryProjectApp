import { writerRepository } from "../../repositories/writerRepository";
import {
  UnauthorizedError,
  NotFoundError,
  BadRequestError,
} from "../../core/errors/apiErrors";

export const writerController = {
  async getDashboard(req: any) {
    const userId: string | undefined =
      req.user?.id ?? req.headers["x-user-id"] ?? undefined;

    if (!userId) {
      throw new UnauthorizedError("Authentication required");
    }

    const data = await writerRepository.getDashboardStats(userId);
    return data;
  },

  async getStories(req: any) {
    const userId: string | undefined =
      req.user?.id ?? req.headers["x-user-id"] ?? undefined;

    if (!userId) {
      throw new UnauthorizedError("Authentication required");
    }

    const stories = await writerRepository.getWriterStories(userId);
    return { items: stories };
  },

  async getStoryById(req: any) {
    const userId: string | undefined =
      req.user?.id ?? req.headers["x-user-id"] ?? undefined;
    const storyId = String(req.params.id ?? "");

    if (!userId) {
      throw new UnauthorizedError("Authentication required");
    }

    if (!storyId) {
      throw new BadRequestError("Story ID is required");
    }

    const story = await writerRepository.getWriterStoryById(userId, storyId);
    if (!story) {
      throw new NotFoundError("Story not found");
    }

    return story;
  },
};
