"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.bookmarksRouter = void 0;
const express_1 = require("express");
const asyncHandler_1 = require("../core/utils/asyncHandler");
const bookmarksController_1 = require("../services/controllers/bookmarksController");
const auth_1 = require("../core/middleware/auth");
exports.bookmarksRouter = (0, express_1.Router)();
exports.bookmarksRouter.get("/", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await bookmarksController_1.bookmarksController.getBookmarks(req);
    res.status(200).json(data);
}));
exports.bookmarksRouter.post("/:storyId", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await bookmarksController_1.bookmarksController.addBookmark(req);
    res.status(201).json(data);
}));
exports.bookmarksRouter.delete("/:storyId", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await bookmarksController_1.bookmarksController.removeBookmark(req);
    res.status(200).json(data);
}));
