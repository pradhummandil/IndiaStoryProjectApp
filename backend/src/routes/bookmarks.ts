import { Router } from "express";
import { asyncHandler } from "../core/utils/asyncHandler";
import { bookmarksController } from "../services/controllers/bookmarksController";
import { authenticate } from "../core/middleware/auth";

export const bookmarksRouter = Router();

bookmarksRouter.get(
  "/",
  authenticate,
  asyncHandler(async (req, res) => {
    const data = await bookmarksController.getBookmarks(req);
    res.status(200).json(data);
  }),
);

bookmarksRouter.post(
  "/:storyId",
  authenticate,
  asyncHandler(async (req, res) => {
    const data = await bookmarksController.addBookmark(req);
    res.status(201).json(data);
  }),
);

bookmarksRouter.delete(
  "/:storyId",
  authenticate,
  asyncHandler(async (req, res) => {
    const data = await bookmarksController.removeBookmark(req);
    res.status(200).json(data);
  }),
);
