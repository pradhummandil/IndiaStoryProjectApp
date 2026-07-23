"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.authRepository = void 0;
const prismaClient_1 = require("../prisma/prismaClient");
const crypto_1 = __importDefault(require("crypto"));
exports.authRepository = {
    async upsertUserProfile(firebaseUser) {
        const email = firebaseUser.email;
        if (!email)
            throw new Error("Email is required");
        const existing = await prismaClient_1.prisma.userProfile.findUnique({ where: { email } });
        if (existing) {
            return prismaClient_1.prisma.userProfile.update({
                where: { email },
                data: {
                    name: firebaseUser.name || undefined,
                    avatarUrl: firebaseUser.photoURL || undefined,
                    lastActiveAt: new Date(),
                },
            });
        }
        const now = new Date();
        return prismaClient_1.prisma.userProfile.create({
            data: {
                id: crypto_1.default.randomUUID(),
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
