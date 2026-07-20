"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.storiesRouter = void 0;
const express_1 = require("express");
const asyncHandler_1 = require("../core/utils/asyncHandler");
const storiesController_1 = require("../services/controllers/storiesController");
exports.storiesRouter = (0, express_1.Router)();
exports.storiesRouter.get("/", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await storiesController_1.storiesController.getStories(req);
    res.status(200).json(data);
}));
exports.storiesRouter.get("/:slug", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await storiesController_1.storiesController.getStoryBySlug(req);
    res.status(200).json(data);
}));
