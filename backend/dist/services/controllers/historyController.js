"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.historyController = void 0;
const historyRepository_1 = require("../../repositories/historyRepository");
const apiErrors_1 = require("../../core/errors/apiErrors");
exports.historyController = {
    async getHistory(req) {
        const userId = req.user?.id ?? req.headers["x-user-id"] ?? undefined;
        if (!userId)
            throw new apiErrors_1.BadRequestError("Unauthorized");
        const { page, limit, filter, search } = req.query ?? {};
        return historyRepository_1.historyRepository.getHistory(userId, {
            page,
            limit,
            filter,
            search,
        });
    },
    async deleteHistoryItem(req) {
        const userId = req.user?.id ?? req.headers["x-user-id"] ?? undefined;
        if (!userId)
            throw new apiErrors_1.BadRequestError("Unauthorized");
        const storyId = String(req.params?.storyId ?? "");
        if (!storyId)
            throw new apiErrors_1.BadRequestError("storyId is required");
        return historyRepository_1.historyRepository.deleteHistoryItem(userId, storyId);
    },
    async clearHistory(req) {
        const userId = req.user?.id ?? req.headers["x-user-id"] ?? undefined;
        if (!userId)
            throw new apiErrors_1.BadRequestError("Unauthorized");
        return historyRepository_1.historyRepository.clearHistory(userId);
    },
};
