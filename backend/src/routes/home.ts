import { Router } from "express";
import { asyncHandler } from "../core/utils/asyncHandler";
import { homeController } from "../services/controllers/homeController";

export const homeRouter = Router();

homeRouter.get(
  "/",
  asyncHandler(async (_req, res) => {
    const result = await homeController.getHome();
    res.status(200).json(result);
  }),
);
