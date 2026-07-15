import type { NextFunction, Request, Response, RequestHandler } from 'express';
import { AppError } from '../errors/httpErrors';

export function asyncHandler(
  fn: (req: Request, res: Response, next: NextFunction) => Promise<any>,
): RequestHandler {
  return (req, res, next) => {
    fn(req, res, next).catch((err) => {
      if (err instanceof AppError) return next(err);
      next(new AppError('Internal Server Error', 500, err));
    });
  };
}

