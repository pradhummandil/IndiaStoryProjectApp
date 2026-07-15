import type { NextFunction, Request, Response } from 'express';

import { logger } from '../logger/logger';
import { env } from '../../config/env';

export class AppError extends Error {
  public readonly statusCode: number;
  public readonly details?: unknown;

  constructor(message: string, statusCode = 500, details?: unknown) {
    super(message);
    this.statusCode = statusCode;
    this.details = details;
  }
}

export function notFoundHandler(_req: Request, res: Response): void {
  res.status(404).json({ error: 'Not Found' });
}

export function errorHandler(err: unknown, _req: Request, res: Response, _next: NextFunction): void {
  const e = err instanceof AppError ? err : new AppError('Internal Server Error', 500, err);

  if (env.NODE_ENV !== 'test') {
    logger.error('Request failed', {
      statusCode: e.statusCode,
      message: e.message,
      details: e.details,
    });
  }

  res.status(e.statusCode).json({
    error: e.message,
    ...(env.NODE_ENV === 'production' ? {} : { details: e.details }),
  });
}

