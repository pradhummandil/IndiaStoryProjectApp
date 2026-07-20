import { AppError } from "../errors/httpErrors";
import { HttpStatus } from "../http/HttpStatus";

export class BadRequestError extends AppError {
  constructor(message = "Bad Request", details?: unknown) {
    super(message, HttpStatus.BadRequest, details);
  }
}

export class UnauthorizedError extends AppError {
  constructor(message = "Unauthorized", details?: unknown) {
    super(message, HttpStatus.Unauthorized, details);
  }
}

export class NotFoundError extends AppError {
  constructor(message = "Not Found", details?: unknown) {
    super(message, HttpStatus.NotFound, details);
  }
}

export class InternalServerError extends AppError {
  constructor(message = "Internal Server Error", details?: unknown) {
    super(message, HttpStatus.InternalServerError, details);
  }
}
