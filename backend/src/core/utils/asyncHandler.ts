import type { NextFunction, Request, Response, RequestHandler } from "express";
import { AppError } from "../errors/httpErrors";
import { logger } from "../logger/logger";

export function asyncHandler(
  fn: (req: Request, res: Response, next: NextFunction) => Promise<any>,
): RequestHandler {
  return (req, res, next) => {
    fn(req, res, next).catch((err) => {
      // Log the raw error at the asyncHandler boundary
      const errorObj = err instanceof Error ? err : new Error(String(err));
      logger.error("[asyncHandler] Unhandled error caught", {
        name: errorObj.name,
        message: errorObj.message,
        path: req.path,
        method: req.method,
      });

      if (err instanceof AppError) return next(err);
      next(new AppError("Internal Server Error", 500, err));
    });
  };
}
