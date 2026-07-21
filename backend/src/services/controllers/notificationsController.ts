import { notificationsRepository } from "../../repositories/notificationsRepository";
import { BadRequestError, NotFoundError } from "../../core/errors/apiErrors";

export const notificationsController = {
  async getNotifications(req: any) {
    const userId: string | undefined =
      req.user?.id ?? req.headers["x-user-id"] ?? undefined;
    if (!userId) throw new BadRequestError("Unauthorized");

    const { page, limit, type } = req.query ?? {};

    return notificationsRepository.getNotifications(userId, {
      page,
      limit,
      type,
    });
  },

  async markAsRead(req: any) {
    const userId: string | undefined =
      req.user?.id ?? req.headers["x-user-id"] ?? undefined;
    if (!userId) throw new BadRequestError("Unauthorized");

    const notificationId = String(req.params?.id ?? "");
    if (!notificationId)
      throw new BadRequestError("Notification ID is required");

    const result = await notificationsRepository.markAsRead(
      userId,
      notificationId,
    );
    if (!result) throw new NotFoundError("Notification not found");

    return result;
  },

  async markAllAsRead(req: any) {
    const userId: string | undefined =
      req.user?.id ?? req.headers["x-user-id"] ?? undefined;
    if (!userId) throw new BadRequestError("Unauthorized");

    return notificationsRepository.markAllAsRead(userId);
  },

  async deleteNotification(req: any) {
    const userId: string | undefined =
      req.user?.id ?? req.headers["x-user-id"] ?? undefined;
    if (!userId) throw new BadRequestError("Unauthorized");

    const notificationId = String(req.params?.id ?? "");
    if (!notificationId)
      throw new BadRequestError("Notification ID is required");

    const result = await notificationsRepository.deleteNotification(
      userId,
      notificationId,
    );
    if (!result) throw new NotFoundError("Notification not found");

    return result;
  },

  async getUnreadCount(req: any) {
    const userId: string | undefined =
      req.user?.id ?? req.headers["x-user-id"] ?? undefined;
    if (!userId) throw new BadRequestError("Unauthorized");

    return notificationsRepository.getUnreadCount(userId);
  },
};
