"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.asyncHandler = asyncHandler;
const httpErrors_1 = require("../errors/httpErrors");
function asyncHandler(fn) {
    return (req, res, next) => {
        fn(req, res, next).catch((err) => {
            if (err instanceof httpErrors_1.AppError)
                return next(err);
            next(new httpErrors_1.AppError('Internal Server Error', 500, err));
        });
    };
}
