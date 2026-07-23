import { Router } from "express";
import { asyncHandler } from "../core/utils/asyncHandler";
import { searchController } from "../services/controllers/searchController";
import { authenticate } from "../core/middleware/auth";

export const searchRouter = Router();

searchRouter.get(
  "/",
  asyncHandler(async (req, res) => {
    const data = await searchController.getSearch(req);
    res.status(200).json(data);
  }),
);

searchRouter.get(
  "/suggestions",
  asyncHandler(async (req, res) => {
    const data = await searchController.getSuggestions(req);
    res.status(200).json(data);
  }),
);

searchRouter.get(
  "/trending",
  asyncHandler(async (req, res) => {
    const data = await searchController.getTrending(req);
    res.status(200).json(data);
  }),
);

searchRouter.get(
  "/recent",
  authenticate,
  asyncHandler(async (req, res) => {
    const data = await searchController.getRecentSearches(req);
    res.status(200).json(data);
  }),
);

searchRouter.delete(
  "/:searchId",
  authenticate,
  asyncHandler(async (req, res) => {
    const data = await searchController.deleteSearch(req);
    res.status(200).json(data);
  }),
);

searchRouter.delete(
  "/",
  authenticate,
  asyncHandler(async (req, res) => {
    const data = await searchController.clearSearchHistory(req);
    res.status(200).json(data);
  }),
);
