import { Router } from "express";
import { asyncHandler } from "../core/utils/asyncHandler";
import { authController } from "../services/controllers/authController";
import { authenticate } from "../core/middleware/auth";

export const authRouter = Router();

/**
 * POST /api/auth/login
 * Body: { idToken: string }
 * Response: { token: string, user: User }
 */
authRouter.post(
  "/login",
  asyncHandler(async (req, res) => {
    const result = await authController.login(req);
    res.status(200).json(result);
  }),
);

/**
 * GET /api/auth/me
 * Header: Authorization: Bearer <token>
 * Response: { id, email, name, avatarUrl, ... }
 */
authRouter.get(
  "/me",
  authenticate,
  asyncHandler(async (req, res) => {
    const result = await authController.getMe(req);
    res.status(200).json(result);
  }),
);
