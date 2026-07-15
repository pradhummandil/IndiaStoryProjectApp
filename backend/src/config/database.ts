import mongoose from 'mongoose';
import { env } from './env';
import { logger } from '../core/logger/logger';

export async function connectMongo(): Promise<void> {
  if (!env.MONGO_ENABLED) return;
  if (!env.MONGODB_URI) {
    throw new Error('MONGODB_URI is required when MONGO_ENABLED=true');
  }

  mongoose.set('strictQuery', true);

  await mongoose.connect(env.MONGODB_URI, {
    dbName: env.MONGODB_DB_NAME,
  } as any);

  logger.info('MongoDB connected', { db: env.MONGODB_DB_NAME ?? 'default' });
}

export function getMongoHealth(): 'ok' | 'disabled' {
  return env.MONGO_ENABLED ? 'ok' : 'disabled';
}

