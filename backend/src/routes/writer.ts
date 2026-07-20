import { Router } from "express";
import { asyncHandler } from "../core/utils/asyncHandler";
import { writerController } from "../services/controllers/writerController";

export const writerRouter = Router();

// GET /api/writer/dashboard
writerRouter.get(
  "/dashboard",
  asyncHandler(async (req, res) => {
    const data = await writerController.getDashboard(req);
    res.status(200).json(data);
  }),
);

// GET /api/writer/stories
writerRouter.get(
  "/stories",
  asyncHandler(async (req, res) => {
    const data = await writerController.getStories(req);
    res.status(200).json(data);
  }),
);

// GET /api/writer/story/:id
writerRouter.get(
  "/story/:id",
  asyncHandler(async (req, res) => {
    const data = await writerController.getStoryById(req);
    res.status(200).json(data);
  }),
);
