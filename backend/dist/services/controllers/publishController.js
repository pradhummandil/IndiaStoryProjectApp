"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.publishController = void 0;
const publishRepository_1 = require("../../repositories/publishRepository");
const apiErrors_1 = require("../../core/errors/apiErrors");
exports.publishController = {
    async getPublishReview(req) {
        const userId = req.user?.id;
        if (!userId) {
            throw new apiErrors_1.UnauthorizedError("Authentication required");
        }
        const storyId = req.params.storyId;
        if (!storyId) {
            throw new apiErrors_1.BadRequestError("storyId parameter is required");
        }
        const data = await publishRepository_1.publishRepository.getPublishReview(storyId, userId);
        if (!data) {
            throw new apiErrors_1.NotFoundError("Story not found");
        }
        return data;
    },
    async validate(req) {
        const userId = req.user?.id;
        if (!userId) {
            throw new apiErrors_1.UnauthorizedError("Authentication required");
        }
        const { storyId } = req.body ?? {};
        if (!storyId) {
            throw new apiErrors_1.BadRequestError("storyId is required");
        }
        return publishRepository_1.publishRepository.validateForPublish(storyId, userId);
    },
    async publish(req) {
        const userId = req.user?.id;
        if (!userId) {
            throw new apiErrors_1.UnauthorizedError("Authentication required");
        }
        const storyId = req.params.storyId;
        if (!storyId) {
            throw new apiErrors_1.BadRequestError("storyId parameter is required");
        }
        const { scheduledAt } = req.body ?? {};
        const result = await publishRepository_1.publishRepository.publishStory(storyId, userId, scheduledAt);
        if (!result) {
            throw new apiErrors_1.NotFoundError("Story not found");
        }
        if (!result.success) {
            return {
                success: false,
                errors: result.errors,
                message: "Validation failed. Please fix the errors and try again.",
            };
        }
        return result;
    },
};
