import { Router } from "express";
import { asyncHandler } from "../core/utils/asyncHandler";
import { historyController } from "../services/controllers/historyController";
import { authenticate } from "../core/middleware/auth";

export const historyRouter = Router();

historyRouter.get(
  "/",
  authenticate,
  asyncHandler(async (req, res) => {
    const data = await historyController.getHistory(req);
    res.status(200).json(data);
  }),
);

historyRouter.delete(
  "/:storyId",
  authenticate,
  asyncHandler(async (req, res) => {
    const data = await historyController.deleteHistoryItem(req);
    res.status(200).json(data);
  }),
);

historyRouter.delete(
  "/",
  authenticate,
  asyncHandler(async (req, res) => {
    const data = await historyController.clearHistory(req);
    res.status(200).json(data);
  }),
);
