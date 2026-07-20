import { z } from "zod";

// Domain model for auth user.
// NOTE: This file is now Prisma-backed (Mongo/Mongoose removed).

export const UserRoleSchema = z.enum(["reader", "writer", "admin"]);
export type UserRole = z.infer<typeof UserRoleSchema>;

export const UserSchema = z.object({
  name: z.string().min(1).max(120),
  username: z.string().min(3).max(50),
  email: z.string().email().max(254),
  passwordHash: z.string().min(20).max(200),
  avatarUrl: z.string().optional(),
  role: UserRoleSchema.default("reader"),
  isVerified: z.boolean().default(false),
  createdAt: z.date(),
  updatedAt: z.date(),
});

export type User = z.infer<typeof UserSchema>;
