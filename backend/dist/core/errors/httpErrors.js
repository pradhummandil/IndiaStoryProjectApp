"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppError = void 0;
exports.notFoundHandler = notFoundHandler;
exports.errorHandler = errorHandler;
const logger_1 = require("../logger/logger");
const env_1 = require("../../config/env");
class AppError extends Error {
    statusCode;
    details;
    constructor(message, statusCode = 500, details) {
        super(message);
        this.statusCode = statusCode;
        this.details = details;
    }
}
exports.AppError = AppError;
function notFoundHandler(_req, res) {
    res.status(404).json({ error: 'Not Found' });
}
function errorHandler(err, _req, res, _next) {
    const e = err instanceof AppError ? err : new AppError('Internal Server Error', 500, err);
    if (env_1.env.NODE_ENV !== 'test') {
        logger_1.logger.error('Request failed', {
            statusCode: e.statusCode,
            message: e.message,
            details: e.details,
        });
    }
    res.status(e.statusCode).json({
        error: e.message,
        ...(env_1.env.NODE_ENV === 'production' ? {} : { details: e.details }),
    });
}
