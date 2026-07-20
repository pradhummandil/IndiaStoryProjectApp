import { Router } from "express";
import { asyncHandler } from "../core/utils/asyncHandler";
import { profileController } from "../services/controllers/profileController";

export const profileRouter = Router();

profileRouter.get(
  "/",
  asyncHandler(async (req, res) => {
    const data = await profileController.getProfile(req);
    res.status(200).json(data);
  }),
);
