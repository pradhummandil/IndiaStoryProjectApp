import { prisma } from "../prisma/prismaClient";
import crypto from "crypto";

export const authRepository = {
  async upsertUserProfile(firebaseUser: {
    uid: string;
    email: string;
    name?: string;
    photoURL?: string;
  }) {
    const email = firebaseUser.email;
    if (!email) throw new Error("Email is required");

    const existing = await prisma.userProfile.findUnique({ where: { email } });

    if (existing) {
      return prisma.userProfile.update({
        where: { email },
        data: {
          name: firebaseUser.name || undefined,
          avatarUrl: firebaseUser.photoURL || undefined,
          lastActiveAt: new Date(),
        },
      });
    }

    const now = new Date();
    return prisma.userProfile.create({
      data: {
        id: crypto.randomUUID(),
        email,
        name: firebaseUser.name || email.split("@")[0],
        avatarUrl: firebaseUser.photoURL || undefined,
        role: "Reader",
        createdAt: now,
        updatedAt: now,
      },
    });
  },

  async getUserById(userId: string) {
    return prisma.userProfile.findUnique({
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

  async getUserByEmail(email: string) {
    return prisma.userProfile.findUnique({ where: { email } });
  },
};
