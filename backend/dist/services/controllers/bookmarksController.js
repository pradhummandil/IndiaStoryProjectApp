"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.bookmarksController = void 0;
const bookmarksRepository_1 = require("../../repositories/bookmarksRepository");
const apiErrors_1 = require("../../core/errors/apiErrors");
exports.bookmarksController = {
    async getBookmarks(req) {
        const userId = req.user?.id ?? req.headers["x-user-id"];
        if (!userId)
            throw new apiErrors_1.UnauthorizedError("Unauthorized");
        return bookmarksRepository_1.bookmarksRepository.getBookmarks(userId);
    },
    async addBookmark(req) {
        const userId = req.user?.id ?? req.headers["x-user-id"];
        if (!userId)
            throw new apiErrors_1.UnauthorizedError("Unauthorized");
        const storyId = req.params?.storyId ?? req.body?.storyId;
        if (!storyId)
            throw new apiErrors_1.BadRequestError("storyId is required");
        return bookmarksRepository_1.bookmarksRepository.addBookmark(userId, storyId);
    },
    async removeBookmark(req) {
        const userId = req.user?.id ?? req.headers["x-user-id"];
        if (!userId)
            throw new apiErrors_1.UnauthorizedError("Unauthorized");
        const { storyId } = req.params ?? {};
        if (!storyId)
            throw new apiErrors_1.BadRequestError("storyId is required");
        const result = await bookmarksRepository_1.bookmarksRepository.removeBookmark(userId, storyId);
        if (!result)
            throw new apiErrors_1.NotFoundError("Bookmark not found");
        return { success: true };
    },
};
