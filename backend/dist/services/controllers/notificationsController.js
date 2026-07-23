"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.notificationsController = void 0;
const notificationsRepository_1 = require("../../repositories/notificationsRepository");
const apiErrors_1 = require("../../core/errors/apiErrors");
exports.notificationsController = {
    async getNotifications(req) {
        const userId = req.user?.id ?? req.headers["x-user-id"] ?? undefined;
        if (!userId)
            throw new apiErrors_1.BadRequestError("Unauthorized");
        const { page, limit, type } = req.query ?? {};
        return notificationsRepository_1.notificationsRepository.getNotifications(userId, {
            page,
            limit,
            type,
        });
    },
    async markAsRead(req) {
        const userId = req.user?.id ?? req.headers["x-user-id"] ?? undefined;
        if (!userId)
            throw new apiErrors_1.BadRequestError("Unauthorized");
        const notificationId = String(req.params?.id ?? "");
        if (!notificationId)
            throw new apiErrors_1.BadRequestError("Notification ID is required");
        const result = await notificationsRepository_1.notificationsRepository.markAsRead(userId, notificationId);
        if (!result)
            throw new apiErrors_1.NotFoundError("Notification not found");
        return result;
    },
    async markAllAsRead(req) {
        const userId = req.user?.id ?? req.headers["x-user-id"] ?? undefined;
        if (!userId)
            throw new apiErrors_1.BadRequestError("Unauthorized");
        return notificationsRepository_1.notificationsRepository.markAllAsRead(userId);
    },
    async deleteNotification(req) {
        const userId = req.user?.id ?? req.headers["x-user-id"] ?? undefined;
        if (!userId)
            throw new apiErrors_1.BadRequestError("Unauthorized");
        const notificationId = String(req.params?.id ?? "");
        if (!notificationId)
            throw new apiErrors_1.BadRequestError("Notification ID is required");
        const result = await notificationsRepository_1.notificationsRepository.deleteNotification(userId, notificationId);
        if (!result)
            throw new apiErrors_1.NotFoundError("Notification not found");
        return result;
    },
    async getUnreadCount(req) {
        const userId = req.user?.id ?? req.headers["x-user-id"] ?? undefined;
        if (!userId)
            throw new apiErrors_1.BadRequestError("Unauthorized");
        return notificationsRepository_1.notificationsRepository.getUnreadCount(userId);
    },
};
