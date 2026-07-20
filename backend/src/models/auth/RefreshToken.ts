import { z } from "zod";
// Domain model for refresh tokens.
// NOTE: This file is now Prisma-backed (Mongo/Mongoose schema removed).

export const RefreshTokenSchema = z.object({
  userId: z.any(),
  tokenHash: z.string().min(20).max(255),
  expiresAt: z.date(),
  deviceInfo: z.string().optional().default(""),
  revoked: z.boolean(),
  createdAt: z.date(),
  updatedAt: z.date(),
});

export type RefreshToken = z.infer<typeof RefreshTokenSchema>;

// Convenience alias for existing call sites that might expect this type.
export type RefreshTokenUserId = string;
