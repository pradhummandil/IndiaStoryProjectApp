"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.connectMongo = connectMongo;
exports.getMongoHealth = getMongoHealth;
const mongoose_1 = __importDefault(require("mongoose"));
const env_1 = require("./env");
const logger_1 = require("../core/logger/logger");
async function connectMongo() {
    if (!env_1.env.MONGO_ENABLED) {
        logger_1.logger.info("MongoDB disabled");
        return;
    }
    if (!env_1.env.MONGODB_URI) {
        logger_1.logger.warn("MONGODB_URI not set — skipping MongoDB connection");
        return;
    }
    mongoose_1.default.set("strictQuery", true);
    await mongoose_1.default.connect(env_1.env.MONGODB_URI, {
        dbName: env_1.env.MONGODB_DB_NAME,
    });
    logger_1.logger.info("MongoDB connected", { db: env_1.env.MONGODB_DB_NAME ?? "default" });
}
function getMongoHealth() {
    return env_1.env.MONGO_ENABLED && env_1.env.MONGODB_URI ? "ok" : "disabled";
}
