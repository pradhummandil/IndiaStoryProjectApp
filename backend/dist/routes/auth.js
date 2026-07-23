"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.authRouter = void 0;
const express_1 = require("express");
const asyncHandler_1 = require("../core/utils/asyncHandler");
const authController_1 = require("../services/controllers/authController");
const auth_1 = require("../core/middleware/auth");
exports.authRouter = (0, express_1.Router)();
/**
 * POST /api/auth/login
 * Body: { idToken: string }
 * Response: { token: string, user: User }
 */
exports.authRouter.post("/login", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const result = await authController_1.authController.login(req);
    res.status(200).json(result);
}));
/**
 * POST /api/auth/register
 * Body: { idToken: string, name?: string }
 * Response: { token: string, user: User }
 */
exports.authRouter.post("/register", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const result = await authController_1.authController.register(req);
    res.status(200).json(result);
}));
/**
 * POST /api/auth/refresh
 * Header: Authorization: Bearer <token>
 * Response: { token: string }
 */
exports.authRouter.post("/refresh", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const result = await authController_1.authController.refreshToken(req);
    res.status(200).json(result);
}));
/**
 * POST /api/auth/logout
 * Header: Authorization: Bearer <token>
 * Response: { success: true }
 */
exports.authRouter.post("/logout", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const result = await authController_1.authController.logout(req);
    res.status(200).json(result);
}));
/**
 * GET /api/auth/me
 * Header: Authorization: Bearer <token>
 * Response: { id, email, name, avatarUrl, ... }
 */
exports.authRouter.get("/me", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const result = await authController_1.authController.getMe(req);
    res.status(200).json(result);
}));
