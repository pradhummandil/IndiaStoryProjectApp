"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.homeRouter = void 0;
const express_1 = require("express");
const asyncHandler_1 = require("../core/utils/asyncHandler");
const homeController_1 = require("../services/controllers/homeController");
exports.homeRouter = (0, express_1.Router)();
exports.homeRouter.get("/", (0, asyncHandler_1.asyncHandler)(async (_req, res) => {
    const result = await homeController_1.homeController.getHome();
    res.status(200).json(result);
}));
