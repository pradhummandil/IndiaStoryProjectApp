import { Router } from "express";
import { asyncHandler } from "../core/utils/asyncHandler";
import { aiAssistantController } from "../services/controllers/aiAssistantController";

export const aiAssistantRouter = Router();

// GET /api/writer/assistant/context
aiAssistantRouter.get(
  "/context",
  asyncHandler(async (req, res) => {
    const data = await aiAssistantController.getContext(req);
    res.status(200).json(data);
  }),
);

// POST /api/writer/assistant/chat
aiAssistantRouter.post(
  "/chat",
  asyncHandler(async (req, res) => {
    const data = await aiAssistantController.chat(req);
    res.status(200).json(data);
  }),
);

// POST /api/writer/assistant/rewrite
aiAssistantRouter.post(
  "/rewrite",
  asyncHandler(async (req, res) => {
    const data = await aiAssistantController.rewrite(req);
    res.status(200).json(data);
  }),
);

// POST /api/writer/assistant/title
aiAssistantRouter.post(
  "/title",
  asyncHandler(async (req, res) => {
    const data = await aiAssistantController.title(req);
    res.status(200).json(data);
  }),
);

// POST /api/writer/assistant/outline
aiAssistantRouter.post(
  "/outline",
  asyncHandler(async (req, res) => {
    const data = await aiAssistantController.outline(req);
    res.status(200).json(data);
  }),
);

// POST /api/writer/assistant/seo
aiAssistantRouter.post(
  "/seo",
  asyncHandler(async (req, res) => {
    const data = await aiAssistantController.seo(req);
    res.status(200).json(data);
  }),
);

// POST /api/writer/assistant/summary
aiAssistantRouter.post(
  "/summary",
  asyncHandler(async (req, res) => {
    const data = await aiAssistantController.summary(req);
    res.status(200).json(data);
  }),
);
