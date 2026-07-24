import { prisma } from "../prisma/prismaClient";

export const authRepository = {
  async upsertUserProfile(firebaseUser: {
    uid: string;
    email: string;
    name?: string;
    photoURL?: string;
  }) {
    const email = firebaseUser.email;
    const uid = firebaseUser.uid;
    if (!email) throw new Error("Email is required");
    if (!uid) throw new Error("Firebase UID is required");

    // Use Firebase UID as the primary identifier for consistency
    const existing = await prisma.userProfile.findUnique({
      where: { id: uid },
    });

    if (existing) {
      return prisma.userProfile.update({
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
    return prisma.userProfile.create({
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
