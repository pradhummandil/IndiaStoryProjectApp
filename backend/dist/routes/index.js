"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.routes = void 0;
const express_1 = require("express");
const api_1 = require("./api");
exports.routes = (0, express_1.Router)();
// Mount all API routes under /api
exports.routes.use("/api", api_1.apiRouter);
