import { bookmarksRepository } from "../../repositories/bookmarksRepository";
import {
  NotFoundError,
  BadRequestError,
  UnauthorizedError,
} from "../../core/errors/apiErrors";

export const bookmarksController = {
  async getBookmarks(req: any) {
    const userId: string | undefined = req.user?.id ?? req.headers["x-user-id"];
    if (!userId) throw new UnauthorizedError("Unauthorized");

    return bookmarksRepository.getBookmarks(userId);
  },

  async addBookmark(req: any) {
    const userId: string | undefined = req.user?.id ?? req.headers["x-user-id"];
    if (!userId) throw new UnauthorizedError("Unauthorized");

    const storyId = req.params?.storyId ?? req.body?.storyId;
    if (!storyId) throw new BadRequestError("storyId is required");

    return bookmarksRepository.addBookmark(userId, storyId);
  },

  async removeBookmark(req: any) {
    const userId: string | undefined = req.user?.id ?? req.headers["x-user-id"];
    if (!userId) throw new UnauthorizedError("Unauthorized");

    const { storyId } = req.params ?? {};
    if (!storyId) throw new BadRequestError("storyId is required");

    const result = await bookmarksRepository.removeBookmark(userId, storyId);
    if (!result) throw new NotFoundError("Bookmark not found");
    return { success: true };
  },
};
