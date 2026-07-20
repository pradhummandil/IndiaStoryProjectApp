import { Router } from "express";
import { asyncHandler } from "../core/utils/asyncHandler";
import { categoriesController } from "../services/controllers/categoriesController";

export const categoriesRouter = Router();

categoriesRouter.get(
  "/",
  asyncHandler(async (_req, res) => {
    const data = await categoriesController.getCategories();
    res.status(200).json(data);
  }),
);
