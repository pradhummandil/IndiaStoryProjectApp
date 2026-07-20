"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.categoriesRouter = void 0;
const express_1 = require("express");
const asyncHandler_1 = require("../core/utils/asyncHandler");
const categoriesController_1 = require("../services/controllers/categoriesController");
exports.categoriesRouter = (0, express_1.Router)();
exports.categoriesRouter.get("/", (0, asyncHandler_1.asyncHandler)(async (_req, res) => {
    const data = await categoriesController_1.categoriesController.getCategories();
    res.status(200).json(data);
}));
