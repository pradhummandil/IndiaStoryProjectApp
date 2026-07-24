"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.startServer = startServer;
const http_1 = __importDefault(require("http"));
const env_1 = require("./config/env");
const database_1 = require("./config/database");
const app_1 = require("./app");
const socket_1 = require("./realtime/socket");
const cloudinary_1 = require("./config/cloudinary");
const firebase_1 = require("./config/firebase");
const logger_1 = require("./core/logger/logger");
async function startServer() {
    // Log startup configuration
    logger_1.logger.info("Starting India Story Project backend...", {
        env: env_1.env.NODE_ENV,
        port: env_1.env.PORT,
        mongo: env_1.env.MONGO_ENABLED ? "enabled" : "disabled",
        firebase: env_1.env.FIREBASE_ENABLED ? "enabled" : "disabled",
        cloudinary: env_1.env.CLOUDINARY_ENABLED ? "enabled" : "disabled",
    });
    // Infrastructure configuration (no routes/models)
    (0, cloudinary_1.configureCloudinary)();
    (0, firebase_1.configureFirebaseAdmin)();
    // Express app
    const app = await (0, app_1.buildApp)();
    // HTTP server
    const server = http_1.default.createServer(app);
    // Socket.IO bootstrap
    (0, socket_1.createSocketServer)(server);
    // Mongo connection — only if enabled AND URI is provided
    await (0, database_1.connectMongo)();
    server.listen(env_1.env.PORT, () => {
        logger_1.logger.info(`India Story Project backend listening on port ${env_1.env.PORT}`, {
            env: env_1.env.NODE_ENV,
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
