"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.aiAssistantRouter = void 0;
const express_1 = require("express");
const asyncHandler_1 = require("../core/utils/asyncHandler");
const aiAssistantController_1 = require("../services/controllers/aiAssistantController");
exports.aiAssistantRouter = (0, express_1.Router)();
// GET /api/writer/assistant/context
exports.aiAssistantRouter.get("/context", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await aiAssistantController_1.aiAssistantController.getContext(req);
    res.status(200).json(data);
}));
// POST /api/writer/assistant/chat
exports.aiAssistantRouter.post("/chat", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await aiAssistantController_1.aiAssistantController.chat(req);
    res.status(200).json(data);
}));
// POST /api/writer/assistant/rewrite
exports.aiAssistantRouter.post("/rewrite", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await aiAssistantController_1.aiAssistantController.rewrite(req);
    res.status(200).json(data);
}));
// POST /api/writer/assistant/title
exports.aiAssistantRouter.post("/title", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await aiAssistantController_1.aiAssistantController.title(req);
    res.status(200).json(data);
}));
// POST /api/writer/assistant/outline
exports.aiAssistantRouter.post("/outline", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await aiAssistantController_1.aiAssistantController.outline(req);
    res.status(200).json(data);
}));
// POST /api/writer/assistant/seo
exports.aiAssistantRouter.post("/seo", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await aiAssistantController_1.aiAssistantController.seo(req);
    res.status(200).json(data);
}));
// POST /api/writer/assistant/summary
exports.aiAssistantRouter.post("/summary", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await aiAssistantController_1.aiAssistantController.summary(req);
    res.status(200).json(data);
}));
