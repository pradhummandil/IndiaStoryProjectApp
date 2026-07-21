import { Router } from "express";
import { asyncHandler } from "../core/utils/asyncHandler";
import { historyController } from "../services/controllers/historyController";

export const historyRouter = Router();

historyRouter.get(
  "/",
  asyncHandler(async (req, res) => {
    const data = await historyController.getHistory(req);
    res.status(200).json(data);
  }),
);

historyRouter.delete(
  "/:storyId",
  asyncHandler(async (req, res) => {
    const data = await historyController.deleteHistoryItem(req);
    res.status(200).json(data);
  }),
);

historyRouter.delete(
  "/",
  asyncHandler(async (req, res) => {
    const data = await historyController.clearHistory(req);
    res.status(200).json(data);
  }),
);
