import express, { type Express, type Request, type Response } from "express";
import compression from "compression";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import cookieParser from "cookie-parser";
import rateLimit from "express-rate-limit";

import { env } from "./config/env";
import { configureLogger, httpLoggerStream } from "./config/logger";
import { errorHandler, notFoundHandler } from "./core/errors/httpErrors";
import { asyncHandler } from "./core/utils/asyncHandler";
import { applyRequestValidation } from "./core/middleware/requestValidation";
import { routes } from "./routes";

export async function buildApp(): Promise<Express> {
  const app = express();

  configureLogger();

  // Environment validation already executed on import.
  // Mongo connection is prepared but can be delayed to server.ts.

  // Trust proxy if behind load balancers.
  app.set("trust proxy", env.TRUST_PROXY);

  // Body parsing
  app.use(express.json({ limit: env.JSON_BODY_LIMIT }));
  app.use(
    express.urlencoded({ extended: false, limit: env.URL_ENCODED_LIMIT }),
  );

  // Security
  app.use(helmet());

  // CORS
  app.use(
    cors({
      origin: env.CORS_ORIGIN,
      credentials: env.CORS_CREDENTIALS,
      methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    }),
  );

  // Compression
  app.use(compression());

  // Cookies
  app.use(cookieParser());

  // Rate limiting
  app.use(
    rateLimit({
      windowMs: env.RATE_LIMIT_WINDOW_MS,
      limit: env.RATE_LIMIT_MAX_REQUESTS,
      standardHeaders: true,
      legacyHeaders: false,
    }),
  );

  // Logging
  app.use(morgan(env.MORGAN_FORMAT, { stream: httpLoggerStream }));

  // Request validation structure (placeholder for future validators)
  applyRequestValidation(app);

  // Health check endpoint
  app.get(
    "/health",
    asyncHandler(async (_req: Request, res: Response) => {
      const ok = true;
      res.status(200).json({
        status: ok ? "ok" : "degraded",
        uptimeSeconds: process.uptime(),
        mongo: env.MONGO_ENABLED ? "configured" : "disabled",
        env: env.NODE_ENV,
      });
    }),
  );

  // Mount feature API routes
  app.use(routes);

  // Not found
  app.use(notFoundHandler);

  // Global error handler
  app.use(errorHandler);

  return app;
}
