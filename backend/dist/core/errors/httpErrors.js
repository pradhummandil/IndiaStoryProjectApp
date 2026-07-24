"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppError = void 0;
exports.successResponse = successResponse;
exports.notFoundHandler = notFoundHandler;
exports.errorHandler = errorHandler;
const client_1 = require("@prisma/client");
const logger_1 = require("../logger/logger");
const env_1 = require("../../config/env");
class AppError extends Error {
    statusCode;
    details;
    code;
    constructor(message, statusCode = 500, details) {
        super(message);
        this.name = "AppError";
        this.statusCode = statusCode;
        this.details = details;
        this.code = getCodeFromStatus(statusCode);
    }
}
exports.AppError = AppError;
function getCodeFromStatus(statusCode) {
    switch (statusCode) {
        case 400:
            return "BAD_REQUEST";
        case 401:
            return "UNAUTHORIZED";
        case 403:
            return "FORBIDDEN";
        case 404:
            return "NOT_FOUND";
        case 409:
            return "CONFLICT";
        case 422:
            return "UNPROCESSABLE_ENTITY";
        case 429:
            return "TOO_MANY_REQUESTS";
        case 500:
            return "INTERNAL_SERVER_ERROR";
        default:
            return "ERROR";
    }
}
/**
 * Standardized success response.
 */
function successResponse(data) {
    return { success: true, data };
}
/**
 * Standardized error response shape.
 */
function errorBody(code, message, details) {
    return {
        success: false,
        message,
        code,
        details: details ?? null,
    };
}
function notFoundHandler(_req, res) {
    res
        .status(404)
        .json(errorBody("NOT_FOUND", "The requested resource was not found"));
}
/**
 * Extract Prisma error code from a Prisma error.
 */
function getPrismaErrorCode(err) {
    if (err instanceof client_1.Prisma.PrismaClientKnownRequestError) {
        return err.code;
    }
    return undefined;
}
/**
 * Extract Firebase error code from a Firebase Auth error.
 */
function getFirebaseErrorCode(err) {
    if (err && typeof err === "object" && "code" in err) {
        const code = err.code;
        if (typeof code === "string" && code.startsWith("auth/")) {
            return code;
        }
    }
    return undefined;
}
function errorHandler(err, _req, res, _next) {
    const errorObj = err instanceof Error ? err : new Error(String(err));
    const prismaCode = getPrismaErrorCode(err);
    const firebaseCode = getFirebaseErrorCode(err);
    // Determine status code and message
    let statusCode = 500;
    let message = "Internal Server Error";
    let code = "INTERNAL_SERVER_ERROR";
    let details = err;
    if (err instanceof AppError) {
        statusCode = err.statusCode;
        message = err.message;
        code = err.code;
        details = err.details;
    }
    else if (prismaCode) {
        // Prisma errors → 500 unless it's a known client error
        if (prismaCode === "P2002") {
            statusCode = 409;
            message = "Resource already exists";
            code = "CONFLICT";
        }
        else if (prismaCode === "P2025") {
            statusCode = 404;
            message = "Resource not found";
            code = "NOT_FOUND";
        }
    }
    // Always log full error details in all environments
    logger_1.logger.error("Request failed Internal Server Error", {
        error: {
            name: errorObj.name,
            message: errorObj.message,
            stack: errorObj.stack,
            statusCode,
            code,
            prismaCode: prismaCode ?? null,
            firebaseCode: firebaseCode ?? null,
            details: details instanceof Error ? details.message : details,
        },
    });
    res
        .status(statusCode)
        .json(errorBody(code, message, env_1.env.NODE_ENV === "production" && statusCode >= 500
        ? {}
        : details instanceof Error
            ? { message: details.message }
            : details));
}
