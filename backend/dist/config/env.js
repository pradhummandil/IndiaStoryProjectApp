"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.env = void 0;
const dotenv_1 = __importDefault(require("dotenv"));
const zod_1 = require("zod");
// Load .env BEFORE any env parsing
dotenv_1.default.config();
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
const coerceBoolean = (defaultVal) => zod_1.z
    .string()
    .optional()
    .transform((val) => {
    if (val === undefined || val === null || val === "")
        return defaultVal;
    const lower = val.toLowerCase().trim();
    if (["false", "0", "no", "off", "disabled"].includes(lower))
        return false;
    if (["true", "1", "yes", "on", "enabled"].includes(lower))
        return true;
    return defaultVal;
});
const EnvSchema = zod_1.z.object({
    NODE_ENV: zod_1.z
        .enum(["development", "test", "production"])
        .default("development"),
    PORT: zod_1.z.coerce.number().int().positive().default(3000),
    TRUST_PROXY: coerceBoolean(true),
    // CORS
    CORS_ORIGIN: zod_1.z.string().default("*"),
    CORS_CREDENTIALS: coerceBoolean(true),
    // Rate limiting
    RATE_LIMIT_WINDOW_MS: zod_1.z.coerce
        .number()
        .int()
        .positive()
        .default(15 * 60 * 1000),
    RATE_LIMIT_MAX_REQUESTS: zod_1.z.coerce.number().int().positive().default(200),
    // Morgan
    MORGAN_FORMAT: zod_1.z.string().default("combined"),
    // Body sizes
    JSON_BODY_LIMIT: zod_1.z.string().default("1mb"),
    URL_ENCODED_LIMIT: zod_1.z.string().default("1mb"),
    // Mongo
    MONGO_ENABLED: coerceBoolean(false),
    MONGODB_URI: zod_1.z.string().optional(),
    MONGODB_DB_NAME: zod_1.z.string().optional(),
    // Cloudinary
    CLOUDINARY_ENABLED: coerceBoolean(false),
    CLOUDINARY_CLOUD_NAME: zod_1.z.string().optional(),
    CLOUDINARY_API_KEY: zod_1.z.string().optional(),
    CLOUDINARY_API_SECRET: zod_1.z.string().optional(),
    // Firebase Admin
    FIREBASE_ENABLED: coerceBoolean(false),
    FIREBASE_SERVICE_ACCOUNT_JSON: zod_1.z.string().optional(),
    FIREBASE_PROJECT_ID: zod_1.z.string().optional(),
    // Socket.IO
    SOCKET_IO_CORS_ORIGIN: zod_1.z.string().default("*"),
    // Misc
    REQUEST_ID_HEADER: zod_1.z.string().default("x-request-id"),
    // JWT
    JWT_SECRET: zod_1.z.string().optional(),
});
exports.env = (() => {
    const parsed = EnvSchema.safeParse(process.env);
    if (parsed.success)
        return parsed.data;
    console.error("Invalid environment variables:", parsed.error.flatten().fieldErrors);
    throw new Error("Environment validation failed");
})();
