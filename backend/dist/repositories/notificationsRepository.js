"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.notificationsRepository = void 0;
const prismaClient_1 = require("../prisma/prismaClient");
function toPositiveInt(value, fallback, max) {
    const n = typeof value === "string" ? Number(value) : Number(value);
    if (!Number.isFinite(n))
        return fallback;
    const i = Math.floor(n);
    if (i <= 0)
        return fallback;
    return Math.min(i, max);
}
exports.notificationsRepository = {
    async getNotifications(userId, params) {
        const page = toPositiveInt(params.page, 1, 1000);
        const limit = toPositiveInt(params.limit, 20, 100);
        const skip = (page - 1) * limit;
        const where = { userId };
        if (params.type && params.type !== "all") {
            if (params.type === "activity") {
                where.type = {
                    in: ["READING_CLUB", "COMMUNITY", "ACHIEVEMENT", "CHALLENGE"],
                };
            }
            else if (params.type === "system") {
                where.type = { in: ["SYSTEM", "ADMIN_MESSAGE", "WRITER_UPDATE"] };
            }
        }
        const [items, total, unreadCount] = await Promise.all([
            prismaClient_1.prisma.notification.findMany({
                where,
                skip,
                take: limit,
                orderBy: { createdAt: "desc" },
            }),
            prismaClient_1.prisma.notification.count({ where }),
            prismaClient_1.prisma.notification.count({ where: { userId, isRead: false } }),
        ]);
        return {
            page,
            limit,
            total,
            unreadCount,
            items,
        };
    },
    async markAsRead(userId, notificationId) {
        const notification = await prismaClient_1.prisma.notification.findFirst({
            where: { id: notificationId, userId },
        });
        if (!notification)
            return null;
        return prismaClient_1.prisma.notification.update({
            where: { id: notificationId },
            data: { isRead: true },
        });
    },
    async markAllAsRead(userId) {
        await prismaClient_1.prisma.notification.updateMany({
            where: { userId, isRead: false },
            data: { isRead: true },
        });
        return { success: true };
    },
    async deleteNotification(userId, notificationId) {
        const notification = await prismaClient_1.prisma.notification.findFirst({
            where: { id: notificationId, userId },
        });
        if (!notification)
            return null;
        await prismaClient_1.prisma.notification.delete({
            where: { id: notificationId },
        });
        return { success: true };
    },
    async getUnreadCount(userId) {
        const count = await prismaClient_1.prisma.notification.count({
            where: { userId, isRead: false },
        });
        return { count };
    },
};
