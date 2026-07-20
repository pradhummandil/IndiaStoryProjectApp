"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.InternalServerError = exports.NotFoundError = exports.UnauthorizedError = exports.BadRequestError = void 0;
const httpErrors_1 = require("../errors/httpErrors");
const HttpStatus_1 = require("../http/HttpStatus");
class BadRequestError extends httpErrors_1.AppError {
    constructor(message = "Bad Request", details) {
        super(message, HttpStatus_1.HttpStatus.BadRequest, details);
    }
}
exports.BadRequestError = BadRequestError;
class UnauthorizedError extends httpErrors_1.AppError {
    constructor(message = "Unauthorized", details) {
        super(message, HttpStatus_1.HttpStatus.Unauthorized, details);
    }
}
exports.UnauthorizedError = UnauthorizedError;
class NotFoundError extends httpErrors_1.AppError {
    constructor(message = "Not Found", details) {
        super(message, HttpStatus_1.HttpStatus.NotFound, details);
    }
}
exports.NotFoundError = NotFoundError;
class InternalServerError extends httpErrors_1.AppError {
    constructor(message = "Internal Server Error", details) {
        super(message, HttpStatus_1.HttpStatus.InternalServerError, details);
    }
}
exports.InternalServerError = InternalServerError;
