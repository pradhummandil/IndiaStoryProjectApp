"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.profileController = void 0;
const profileRepository_1 = require("../../repositories/profileRepository");
const apiErrors_1 = require("../../core/errors/apiErrors");
exports.profileController = {
    async getProfile(req) {
        // Non-breaking: accept user id from header if auth middleware already sets it.
        // Common pattern in existing codebases: req.user?.id
        const userId = req.user?.id ?? req.headers["x-user-id"] ?? undefined;
        const profile = await profileRepository_1.profileRepository.getProfile(userId ?? null);
        if (!userId)
            throw new apiErrors_1.UnauthorizedError("Unauthorized");
        if (!profile)
            throw new apiErrors_1.NotFoundError("Profile not found");
        return profile;
    },
};
