"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.profileRouter = void 0;
const express_1 = require("express");
const asyncHandler_1 = require("../core/utils/asyncHandler");
const profileController_1 = require("../services/controllers/profileController");
const auth_1 = require("../core/middleware/auth");
exports.profileRouter = (0, express_1.Router)();
exports.profileRouter.get("/", auth_1.authenticate, (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const data = await profileController_1.profileController.getProfile(req);
    res.status(200).json(data);
}));
