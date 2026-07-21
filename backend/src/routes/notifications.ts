import { Router } from "express";
import { asyncHandler } from "../core/utils/asyncHandler";
import { notificationsController } from "../services/controllers/notificationsController";

export const notificationsRouter = Router();

// GET /api/notifications — paginated list
notificationsRouter.get(
  "/",
  asyncHandler(async (req, res) => {
    const data = await notificationsController.getNotifications(req);
    res.status(200).json(data);
  }),
);

// GET /api/notifications/unread-count — unread count badge
notificationsRouter.get(
  "/unread-count",
  asyncHandler(async (req, res) => {
    const data = await notificationsController.getUnreadCount(req);
    res.status(200).json(data);
  }),
);

// PATCH /api/notifications/:id/read — mark one as read
notificationsRouter.patch(
  "/:id/read",
  asyncHandler(async (req, res) => {
    const data = await notificationsController.markAsRead(req);
    res.status(200).json(data);
  }),
);

// PATCH /api/notifications/read-all — mark all as read
notificationsRouter.patch(
  "/read-all",
  asyncHandler(async (req, res) => {
    const data = await notificationsController.markAllAsRead(req);
    res.status(200).json(data);
  }),
);

// DELETE /api/notifications/:id — delete single notification
notificationsRouter.delete(
  "/:id",
  asyncHandler(async (req, res) => {
    const data = await notificationsController.deleteNotification(req);
    res.status(200).json(data);
  }),
);
