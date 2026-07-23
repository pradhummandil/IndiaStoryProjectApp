"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.historyRouter = void 0;
const express_1 = require("express");
const asyncHandler_1 = require("../core/utils/asyncHandler");
const historyController_1 = require("../services/controllers/historyController");
const auth_1 = require("../core/middleware/auth");
exports.historyRouter = (0, express_1.Router)();
exports.historyRouter.get("/", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await historyController_1.historyController.getHistory(req);
    res.status(200).json(data);
}));
exports.historyRouter.delete("/:storyId", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await historyController_1.historyController.deleteHistoryItem(req);
    res.status(200).json(data);
}));
exports.historyRouter.delete("/", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await historyController_1.historyController.clearHistory(req);
    res.status(200).json(data);
}));
