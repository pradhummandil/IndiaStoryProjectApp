"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UserSchema = exports.UserRoleSchema = void 0;
const zod_1 = require("zod");
// Domain model for auth user.
// NOTE: This file is now Prisma-backed (Mongo/Mongoose removed).
exports.UserRoleSchema = zod_1.z.enum(["reader", "writer", "admin"]);
exports.UserSchema = zod_1.z.object({
    name: zod_1.z.string().min(1).max(120),
    username: zod_1.z.string().min(3).max(50),
    email: zod_1.z.string().email().max(254),
    passwordHash: zod_1.z.string().min(20).max(200),
    avatarUrl: zod_1.z.string().optional(),
    role: exports.UserRoleSchema.default("reader"),
    isVerified: zod_1.z.boolean().default(false),
    createdAt: zod_1.z.date(),
    updatedAt: zod_1.z.date(),
});
