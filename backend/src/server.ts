import http from "http";

import { env } from "./config/env";
import { connectMongo } from "./config/database";
import { buildApp } from "./app";
import { createSocketServer } from "./realtime/socket";

import { configureCloudinary } from "./config/cloudinary";
import { configureFirebaseAdmin } from "./config/firebase";
import { logger } from "./core/logger/logger";

export async function startServer(): Promise<void> {
  // Log startup configuration
  logger.info("Starting India Story Project backend...", {
    env: env.NODE_ENV,
    port: env.PORT,
    mongo: env.MONGO_ENABLED ? "enabled" : "disabled",
    firebase: env.FIREBASE_ENABLED ? "enabled" : "disabled",
    cloudinary: env.CLOUDINARY_ENABLED ? "enabled" : "disabled",
  });

  // Infrastructure configuration (no routes/models)
  configureCloudinary();
  configureFirebaseAdmin();

  // Express app
  const app = await buildApp();

  // HTTP server
  const server = http.createServer(app);

  // Socket.IO bootstrap
  createSocketServer(server);

  // Mongo connection — only if enabled AND URI is provided
  await connectMongo();

  server.listen(env.PORT, () => {
    logger.info(`India Story Project backend listening on port ${env.PORT}`, {
      env: env.NODE_ENV,
    });
  });
}

// Allow `node dist/server.js` style usage.
if (require.main === module) {
  startServer().catch((err) => {
    // eslint-disable-next-line no-console
    console.error("Fatal error starting server:", err);
    process.exit(1);
  });
}
