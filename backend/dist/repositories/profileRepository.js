"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.profileRepository = void 0;
const prismaClient_1 = require("../prisma/prismaClient");
exports.profileRepository = {
    async getProfile(userId) {
        // TODO: integrate with auth (do not modify auth UI). For now, rely on an optional header.
        // If userId missing, return 401.
        if (!userId)
            return null;
        const profile = await prismaClient_1.prisma.userProfile.findUnique({
            where: { id: userId },
            select: {
                id: true,
                email: true,
                name: true,
                avatarUrl: true,
                role: true,
                level: true,
                readingStreak: true,
                totalReadingTime: true,
                totalXP: true,
                favoriteState: true,
                favoriteTheme: true,
            },
        });
        return profile;
    },
};
