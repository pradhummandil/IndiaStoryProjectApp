"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.asyncHandler = asyncHandler;
const httpErrors_1 = require("../errors/httpErrors");
const logger_1 = require("../logger/logger");
function asyncHandler(fn) {
    return (req, res, next) => {
        fn(req, res, next).catch((err) => {
            // Log the raw error at the asyncHandler boundary
            const errorObj = err instanceof Error ? err : new Error(String(err));
            logger_1.logger.error("[asyncHandler] Unhandled error caught", {
                name: errorObj.name,
                message: errorObj.message,
                path: req.path,
                method: req.method,
            });
            if (err instanceof httpErrors_1.AppError)
                return next(err);
            next(new httpErrors_1.AppError("Internal Server Error", 500, err));
        });
    };
}
