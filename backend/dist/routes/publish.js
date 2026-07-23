"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.publishRouter = void 0;
const express_1 = require("express");
const asyncHandler_1 = require("../core/utils/asyncHandler");
const publishController_1 = require("../services/controllers/publishController");
exports.publishRouter = (0, express_1.Router)();
// GET /api/writer/publish/:storyId - Fetch publish review data
exports.publishRouter.get("/:storyId", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await publishController_1.publishController.getPublishReview(req);
    res.status(200).json(data);
}));
// POST /api/writer/publish/validate - Validate story before publishing
exports.publishRouter.post("/validate", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await publishController_1.publishController.validate(req);
    res.status(200).json(data);
}));
// POST /api/writer/publish/:storyId - Publish a story
exports.publishRouter.post("/:storyId", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await publishController_1.publishController.publish(req);
    res.status(200).json(data);
}));
