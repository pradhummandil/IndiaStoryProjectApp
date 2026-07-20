import { Router } from "express";
import { asyncHandler } from "../core/utils/asyncHandler";
import { bookmarksController } from "../services/controllers/bookmarksController";

export const bookmarksRouter = Router();

bookmarksRouter.get(
  "/",
  asyncHandler(async (req, res) => {
    const data = await bookmarksController.getBookmarks(req);
    res.status(200).json(data);
  }),
);

bookmarksRouter.post(
  "/:storyId",
  asyncHandler(async (req, res) => {
    const data = await bookmarksController.addBookmark(req);
    res.status(201).json(data);
  }),
);

bookmarksRouter.delete(
  "/:storyId",
  asyncHandler(async (req, res) => {
    const data = await bookmarksController.removeBookmark(req);
    res.status(200).json(data);
  }),
);
