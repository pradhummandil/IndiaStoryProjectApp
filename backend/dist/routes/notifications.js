"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.notificationsRouter = void 0;
const express_1 = require("express");
const asyncHandler_1 = require("../core/utils/asyncHandler");
const notificationsController_1 = require("../services/controllers/notificationsController");
const auth_1 = require("../core/middleware/auth");
exports.notificationsRouter = (0, express_1.Router)();
// GET /api/notifications — paginated list
exports.notificationsRouter.get("/", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await notificationsController_1.notificationsController.getNotifications(req);
    res.status(200).json(data);
}));
// GET /api/notifications/unread-count — unread count badge
exports.notificationsRouter.get("/unread-count", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await notificationsController_1.notificationsController.getUnreadCount(req);
    res.status(200).json(data);
}));
// PATCH /api/notifications/:id/read — mark one as read
exports.notificationsRouter.patch("/:id/read", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await notificationsController_1.notificationsController.markAsRead(req);
    res.status(200).json(data);
}));
// PATCH /api/notifications/read-all — mark all as read
exports.notificationsRouter.patch("/read-all", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await notificationsController_1.notificationsController.markAllAsRead(req);
    res.status(200).json(data);
}));
// DELETE /api/notifications/:id — delete single notification
exports.notificationsRouter.delete("/:id", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await notificationsController_1.notificationsController.deleteNotification(req);
    res.status(200).json(data);
}));
