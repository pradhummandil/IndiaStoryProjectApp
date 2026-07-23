"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.writerController = void 0;
const writerRepository_1 = require("../../repositories/writerRepository");
const apiErrors_1 = require("../../core/errors/apiErrors");
exports.writerController = {
    async getDashboard(req) {
        const userId = req.user?.id ?? req.headers["x-user-id"] ?? undefined;
        if (!userId) {
            throw new apiErrors_1.UnauthorizedError("Authentication required");
        }
        const data = await writerRepository_1.writerRepository.getDashboardStats(userId);
        return data;
    },
    async getStories(req) {
        const userId = req.user?.id ?? req.headers["x-user-id"] ?? undefined;
        if (!userId) {
            throw new apiErrors_1.UnauthorizedError("Authentication required");
        }
        const stories = await writerRepository_1.writerRepository.getWriterStories(userId);
        return { items: stories };
    },
    async getStoryById(req) {
        const userId = req.user?.id ?? req.headers["x-user-id"] ?? undefined;
        const storyId = String(req.params.id ?? "");
        if (!userId) {
            throw new apiErrors_1.UnauthorizedError("Authentication required");
        }
        if (!storyId) {
            throw new apiErrors_1.BadRequestError("Story ID is required");
        }
        const story = await writerRepository_1.writerRepository.getWriterStoryById(userId, storyId);
        if (!story) {
            throw new apiErrors_1.NotFoundError("Story not found");
        }
        return story;
    },
};
