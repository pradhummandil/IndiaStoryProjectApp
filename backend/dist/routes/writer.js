"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.writerRouter = void 0;
const express_1 = require("express");
const asyncHandler_1 = require("../core/utils/asyncHandler");
const writerController_1 = require("../services/controllers/writerController");
exports.writerRouter = (0, express_1.Router)();
// GET /api/writer/dashboard
exports.writerRouter.get("/dashboard", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await writerController_1.writerController.getDashboard(req);
    res.status(200).json(data);
}));
// GET /api/writer/stories
exports.writerRouter.get("/stories", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await writerController_1.writerController.getStories(req);
    res.status(200).json(data);
}));
// GET /api/writer/story/:id
exports.writerRouter.get("/story/:id", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await writerController_1.writerController.getStoryById(req);
    res.status(200).json(data);
}));
