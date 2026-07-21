import { prisma } from "../prisma/prismaClient";

type PaginationParams = {
  page?: string;
  limit?: string;
  type?: string;
};

function toPositiveInt(value: unknown, fallback: number, max: number): number {
  const n = typeof value === "string" ? Number(value) : Number(value);
  if (!Number.isFinite(n)) return fallback;
  const i = Math.floor(n);
  if (i <= 0) return fallback;
  return Math.min(i, max);
}

export const notificationsRepository = {
  async getNotifications(userId: string, params: PaginationParams) {
    const page = toPositiveInt(params.page, 1, 1000);
    const limit = toPositiveInt(params.limit, 20, 100);
    const skip = (page - 1) * limit;

    const where: any = { userId };

    if (params.type && params.type !== "all") {
      if (params.type === "activity") {
        where.type = {
          in: ["READING_CLUB", "COMMUNITY", "ACHIEVEMENT", "CHALLENGE"],
        };
      } else if (params.type === "system") {
        where.type = { in: ["SYSTEM", "ADMIN_MESSAGE", "WRITER_UPDATE"] };
      }
    }

    const [items, total, unreadCount] = await Promise.all([
      prisma.notification.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: "desc" },
      }),
      prisma.notification.count({ where }),
      prisma.notification.count({ where: { userId, isRead: false } }),
    ]);

    return {
      page,
      limit,
      total,
      unreadCount,
      items,
    };
  },

  async markAsRead(userId: string, notificationId: string) {
    const notification = await prisma.notification.findFirst({
      where: { id: notificationId, userId },
    });
    if (!notification) return null;

    return prisma.notification.update({
      where: { id: notificationId },
      data: { isRead: true },
    });
  },

  async markAllAsRead(userId: string) {
    await prisma.notification.updateMany({
      where: { userId, isRead: false },
      data: { isRead: true },
    });
    return { success: true };
  },

  async deleteNotification(userId: string, notificationId: string) {
    const notification = await prisma.notification.findFirst({
      where: { id: notificationId, userId },
    });
    if (!notification) return null;

    await prisma.notification.delete({
      where: { id: notificationId },
    });
    return { success: true };
  },

  async getUnreadCount(userId: string) {
    const count = await prisma.notification.count({
      where: { userId, isRead: false },
    });
    return { count };
  },
};
