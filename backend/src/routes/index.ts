import { Router } from "express";
import { apiRouter } from "./api";

export const routes = Router();

// Mount all API routes under /api
routes.use("/api", apiRouter);
