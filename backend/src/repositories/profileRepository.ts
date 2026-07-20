import { prisma } from "../prisma/prismaClient";

export const profileRepository = {
  async getProfile(userId?: string | null) {
    // TODO: integrate with auth (do not modify auth UI). For now, rely on an optional header.
    // If userId missing, return 401.
    if (!userId) return null;

    const profile = await prisma.userProfile.findUnique({
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
      } as any,
    });

    return profile;
  },
};
