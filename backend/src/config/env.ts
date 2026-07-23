import dotenv from "dotenv";
import { z } from "zod";

// Load .env BEFORE any env parsing
dotenv.config();

/**
 * Custom boolean schema that correctly handles:
 * - "false", "0", "no", "off" → false
 * - "true", "1", "yes", "on" → true
 * - Anything else → default
 *
 * This fixes the critical bug where z.coerce.boolean() converts
 * the string "false" to `true` because Boolean("false") is
 * truthy in JavaScript (non-empty string).
 */
const coerceBoolean = (defaultVal: boolean) =>
  z
    .string()
    .optional()
    .transform((val) => {
      if (val === undefined || val === null || val === "") return defaultVal;
      const lower = val.toLowerCase().trim();
      if (["false", "0", "no", "off", "disabled"].includes(lower)) return false;
      if (["true", "1", "yes", "on", "enabled"].includes(lower)) return true;
      return defaultVal;
    });

const EnvSchema = z.object({
  NODE_ENV: z
    .enum(["development", "test", "production"])
    .default("development"),
  PORT: z.coerce.number().int().positive().default(3000),

  TRUST_PROXY: coerceBoolean(true),

  // CORS
  CORS_ORIGIN: z.string().default("*"),
  CORS_CREDENTIALS: coerceBoolean(true),

  // Rate limiting
  RATE_LIMIT_WINDOW_MS: z.coerce
    .number()
    .int()
    .positive()
    .default(15 * 60 * 1000),
  RATE_LIMIT_MAX_REQUESTS: z.coerce.number().int().positive().default(200),

  // Morgan
  MORGAN_FORMAT: z.string().default("combined"),

  // Body sizes
  JSON_BODY_LIMIT: z.string().default("1mb"),
  URL_ENCODED_LIMIT: z.string().default("1mb"),

  // Mongo
  MONGO_ENABLED: coerceBoolean(false),
  MONGODB_URI: z.string().optional(),
  MONGODB_DB_NAME: z.string().optional(),

  // Cloudinary
  CLOUDINARY_ENABLED: coerceBoolean(false),
  CLOUDINARY_CLOUD_NAME: z.string().optional(),
  CLOUDINARY_API_KEY: z.string().optional(),
  CLOUDINARY_API_SECRET: z.string().optional(),

  // Firebase Admin
  FIREBASE_ENABLED: coerceBoolean(false),
  FIREBASE_SERVICE_ACCOUNT_JSON: z.string().optional(),
  FIREBASE_PROJECT_ID: z.string().optional(),

  // Socket.IO
  SOCKET_IO_CORS_ORIGIN: z.string().default("*"),

  // Misc
  REQUEST_ID_HEADER: z.string().default("x-request-id"),

  // JWT
  JWT_SECRET: z.string().optional(),
});

export type Env = z.infer<typeof EnvSchema>;

export const env: Env = (() => {
  const parsed = EnvSchema.safeParse(process.env);
  if (parsed.success) return parsed.data;

  console.error(
    "Invalid environment variables:",
    parsed.error.flatten().fieldErrors,
  );
  throw new Error("Environment validation failed");
})();
