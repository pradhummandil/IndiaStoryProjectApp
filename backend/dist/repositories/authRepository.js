"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.authRepository = void 0;
const prismaClient_1 = require("../prisma/prismaClient");
exports.authRepository = {
    async upsertUserProfile(firebaseUser) {
        const email = firebaseUser.email;
        const uid = firebaseUser.uid;
        if (!email)
            throw new Error("Email is required");
        if (!uid)
            throw new Error("Firebase UID is required");
        // Use Firebase UID as the primary identifier for consistency
        const existing = await prismaClient_1.prisma.userProfile.findUnique({
            where: { id: uid },
        });
        if (existing) {
            return prismaClient_1.prisma.userProfile.update({
                where: { id: uid },
                data: {
                    email,
                    name: firebaseUser.name || undefined,
                    avatarUrl: firebaseUser.photoURL || undefined,
                    lastActiveAt: new Date(),
                },
            });
        }
        const now = new Date();
        return prismaClient_1.prisma.userProfile.create({
            data: {
                id: uid, // Use Firebase UID as the user ID
                email,
                name: firebaseUser.name || email.split("@")[0],
                avatarUrl: firebaseUser.photoURL || undefined,
                role: "Reader",
                createdAt: now,
                updatedAt: now,
            },
        });
    },
    async getUserById(userId) {
        return prismaClient_1.prisma.userProfile.findUnique({
            where: { id: userId },
            include: {
                UserStat: true,
                UserBadge: {
                    include: { Badge: true },
                    take: 10,
                },
            },
        });
    },
    async getUserByEmail(email) {
        return prismaClient_1.prisma.userProfile.findUnique({ where: { email } });
    },
};
