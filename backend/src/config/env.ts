import dotenv from 'dotenv';
import { z } from 'zod';

dotenv.config();

const EnvSchema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  PORT: z.coerce.number().int().positive().default(3000),

  TRUST_PROXY: z.coerce.boolean().default(true),

  // CORS
  CORS_ORIGIN: z.string().default('*'),
  CORS_CREDENTIALS: z.coerce.boolean().default(true),

  // Rate limiting
  RATE_LIMIT_WINDOW_MS: z.coerce.number().int().positive().default(15 * 60 * 1000),
  RATE_LIMIT_MAX_REQUESTS: z.coerce.number().int().positive().default(200),

  // Morgan
  MORGAN_FORMAT: z.string().default('combined'),

  // Body sizes
  JSON_BODY_LIMIT: z.string().default('1mb'),
  URL_ENCODED_LIMIT: z.string().default('1mb'),

  // Mongo
  MONGO_ENABLED: z.coerce.boolean().default(true),
  MONGODB_URI: z.string().min(1).optional(),

  MONGODB_DB_NAME: z.string().optional(),

  // Cloudinary
  CLOUDINARY_ENABLED: z.coerce.boolean().default(true),
  CLOUDINARY_CLOUD_NAME: z.string().optional(),
  CLOUDINARY_API_KEY: z.string().optional(),
  CLOUDINARY_API_SECRET: z.string().optional(),

  // Firebase Admin
  FIREBASE_ENABLED: z.coerce.boolean().default(true),
  FIREBASE_SERVICE_ACCOUNT_JSON: z.string().optional(),

  // Socket.IO
  SOCKET_IO_CORS_ORIGIN: z.string().default('*'),

  // Misc
  REQUEST_ID_HEADER: z.string().default('x-request-id'),
});

export type Env = z.infer<typeof EnvSchema>;

export const env: Env = (() => {
  // In production, require these. In development allow missing to keep scaffolding bootable.
  const parsed = EnvSchema.safeParse(process.env);
  if (parsed.success) return parsed.data;

  // If MONGODB_URI missing during scaffolding, provide a clearer message.
  // eslint-disable-next-line no-console
  console.error('Invalid environment variables:', parsed.error.flatten().fieldErrors);
  throw new Error('Environment validation failed');
})();

