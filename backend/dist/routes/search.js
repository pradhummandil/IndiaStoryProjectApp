"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.searchRouter = void 0;
const express_1 = require("express");
const asyncHandler_1 = require("../core/utils/asyncHandler");
const searchController_1 = require("../services/controllers/searchController");
const auth_1 = require("../core/middleware/auth");
exports.searchRouter = (0, express_1.Router)();
exports.searchRouter.get("/", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await searchController_1.searchController.getSearch(req);
    res.status(200).json(data);
}));
exports.searchRouter.get("/suggestions", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await searchController_1.searchController.getSuggestions(req);
    res.status(200).json(data);
}));
exports.searchRouter.get("/trending", (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await searchController_1.searchController.getTrending(req);
    res.status(200).json(data);
}));
exports.searchRouter.get("/recent", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await searchController_1.searchController.getRecentSearches(req);
    res.status(200).json(data);
}));
exports.searchRouter.delete("/:searchId", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await searchController_1.searchController.deleteSearch(req);
    res.status(200).json(data);
}));
exports.searchRouter.delete("/", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await searchController_1.searchController.clearSearchHistory(req);
    res.status(200).json(data);
}));
