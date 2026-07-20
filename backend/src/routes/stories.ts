import { Router } from "express";
import { asyncHandler } from "../core/utils/asyncHandler";
import { storiesController } from "../services/controllers/storiesController";

export const storiesRouter = Router();

storiesRouter.get(
  "/",
  asyncHandler(async (req, res) => {
    const data = await storiesController.getStories(req);
    res.status(200).json(data);
  }),
);

storiesRouter.get(
  "/:slug",
  asyncHandler(async (req, res) => {
    const data = await storiesController.getStoryBySlug(req);
    res.status(200).json(data);
  }),
);
