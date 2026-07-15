"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.buildApp = buildApp;
const express_1 = __importDefault(require("express"));
const compression_1 = __importDefault(require("compression"));
const cors_1 = __importDefault(require("cors"));
const helmet_1 = __importDefault(require("helmet"));
const morgan_1 = __importDefault(require("morgan"));
const cookie_parser_1 = __importDefault(require("cookie-parser"));
const express_rate_limit_1 = __importDefault(require("express-rate-limit"));
const env_1 = require("./config/env");
const logger_1 = require("./config/logger");
const httpErrors_1 = require("./core/errors/httpErrors");
const asyncHandler_1 = require("./core/utils/asyncHandler");
const requestValidation_1 = require("./core/middleware/requestValidation");
// Note: No feature routes/controllers here. We only expose /health.
async function buildApp() {
    const app = (0, express_1.default)();
    (0, logger_1.configureLogger)();
    // Environment validation already executed on import.
    // Mongo connection is prepared but can be delayed to server.ts.
    // Trust proxy if behind load balancers.
    app.set('trust proxy', env_1.env.TRUST_PROXY);
    // Body parsing
    app.use(express_1.default.json({ limit: env_1.env.JSON_BODY_LIMIT }));
    app.use(express_1.default.urlencoded({ extended: false, limit: env_1.env.URL_ENCODED_LIMIT }));
    // Security
    app.use((0, helmet_1.default)());
    // CORS
    app.use((0, cors_1.default)({
        origin: env_1.env.CORS_ORIGIN,
        credentials: env_1.env.CORS_CREDENTIALS,
        methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    }));
    // Compression
    app.use((0, compression_1.default)());
    // Cookies
    app.use((0, cookie_parser_1.default)());
    // Rate limiting
    app.use((0, express_rate_limit_1.default)({
        windowMs: env_1.env.RATE_LIMIT_WINDOW_MS,
        limit: env_1.env.RATE_LIMIT_MAX_REQUESTS,
        standardHeaders: true,
        legacyHeaders: false,
    }));
    // Logging
    app.use((0, morgan_1.default)(env_1.env.MORGAN_FORMAT, { stream: logger_1.httpLoggerStream }));
    // Request validation structure (placeholder for future validators)
    (0, requestValidation_1.applyRequestValidation)(app);
    // Health check endpoint
    app.get('/health', (0, asyncHandler_1.asyncHandler)(async (_req, res) => {
        const ok = true;
        res.status(200).json({
            status: ok ? 'ok' : 'degraded',
            uptimeSeconds: process.uptime(),
            mongo: env_1.env.MONGO_ENABLED ? 'configured' : 'disabled',
            env: env_1.env.NODE_ENV,
        });
    }));
    // Not found
    app.use(httpErrors_1.notFoundHandler);
    // Global error handler
    app.use(httpErrors_1.errorHandler);
    return app;
}
