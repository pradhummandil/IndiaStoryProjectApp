import mongoose from "mongoose";
import { env } from "./env";
import { logger } from "../core/logger/logger";

export async function connectMongo(): Promise<void> {
  if (!env.MONGO_ENABLED) {
    logger.info("MongoDB disabled");
    return;
  }
  if (!env.MONGODB_URI) {
    logger.warn("MONGODB_URI not set — skipping MongoDB connection");
    return;
  }

  mongoose.set("strictQuery", true);

  await mongoose.connect(env.MONGODB_URI, {
    dbName: env.MONGODB_DB_NAME,
  } as any);

  logger.info("MongoDB connected", { db: env.MONGODB_DB_NAME ?? "default" });
}

export function getMongoHealth(): "ok" | "disabled" {
  return env.MONGO_ENABLED && env.MONGODB_URI ? "ok" : "disabled";
}
