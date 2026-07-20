"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RefreshTokenSchema = void 0;
const zod_1 = require("zod");
// Domain model for refresh tokens.
// NOTE: This file is now Prisma-backed (Mongo/Mongoose schema removed).
exports.RefreshTokenSchema = zod_1.z.object({
    userId: zod_1.z.any(),
    tokenHash: zod_1.z.string().min(20).max(255),
    expiresAt: zod_1.z.date(),
    deviceInfo: zod_1.z.string().optional().default(""),
    revoked: zod_1.z.boolean(),
    createdAt: zod_1.z.date(),
    updatedAt: zod_1.z.date(),
});
