import { Router } from "express";
import { asyncHandler } from "../core/utils/asyncHandler";
import { profileController } from "../services/controllers/profileController";
import { authenticate } from "../core/middleware/auth";

export const profileRouter = Router();

profileRouter.get(
  "/",
  authenticate,
  asyncHandler(async (req, res) => {
    const data = await profileController.getProfile(req);
    res.status(200).json(data);
  }),
);
