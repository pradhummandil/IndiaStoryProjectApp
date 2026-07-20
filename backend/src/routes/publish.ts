import { Router } from "express";
import { asyncHandler } from "../core/utils/asyncHandler";
import { publishController } from "../services/controllers/publishController";

export const publishRouter = Router();

// GET /api/writer/publish/:storyId - Fetch publish review data
publishRouter.get(
  "/:storyId",
  asyncHandler(async (req, res) => {
    const data = await publishController.getPublishReview(req);
    res.status(200).json(data);
  }),
);

// POST /api/writer/publish/validate - Validate story before publishing
publishRouter.post(
  "/validate",
  asyncHandler(async (req, res) => {
    const data = await publishController.validate(req);
    res.status(200).json(data);
  }),
);

// POST /api/writer/publish/:storyId - Publish a story
publishRouter.post(
  "/:storyId",
  asyncHandler(async (req, res) => {
    const data = await publishController.publish(req);
    res.status(200).json(data);
  }),
);
