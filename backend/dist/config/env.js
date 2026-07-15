"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.env = void 0;
const dotenv_1 = __importDefault(require("dotenv"));
const zod_1 = require("zod");
dotenv_1.default.config();
const EnvSchema = zod_1.z.object({
    NODE_ENV: zod_1.z.enum(['development', 'test', 'production']).default('development'),
    PORT: zod_1.z.coerce.number().int().positive().default(3000),
    TRUST_PROXY: zod_1.z.coerce.boolean().default(true),
    // CORS
    CORS_ORIGIN: zod_1.z.string().default('*'),
    CORS_CREDENTIALS: zod_1.z.coerce.boolean().default(true),
    // Rate limiting
    RATE_LIMIT_WINDOW_MS: zod_1.z.coerce.number().int().positive().default(15 * 60 * 1000),
    RATE_LIMIT_MAX_REQUESTS: zod_1.z.coerce.number().int().positive().default(200),
    // Morgan
    MORGAN_FORMAT: zod_1.z.string().default('combined'),
    // Body sizes
    JSON_BODY_LIMIT: zod_1.z.string().default('1mb'),
    URL_ENCODED_LIMIT: zod_1.z.string().default('1mb'),
    // Mongo
    MONGO_ENABLED: zod_1.z.coerce.boolean().default(true),
    MONGODB_URI: zod_1.z.string().min(1).optional(),
    MONGODB_DB_NAME: zod_1.z.string().optional(),
    // Cloudinary
    CLOUDINARY_ENABLED: zod_1.z.coerce.boolean().default(true),
    CLOUDINARY_CLOUD_NAME: zod_1.z.string().optional(),
    CLOUDINARY_API_KEY: zod_1.z.string().optional(),
    CLOUDINARY_API_SECRET: zod_1.z.string().optional(),
    // Firebase Admin
    FIREBASE_ENABLED: zod_1.z.coerce.boolean().default(true),
    FIREBASE_SERVICE_ACCOUNT_JSON: zod_1.z.string().optional(),
    // Socket.IO
    SOCKET_IO_CORS_ORIGIN: zod_1.z.string().default('*'),
    // Misc
    REQUEST_ID_HEADER: zod_1.z.string().default('x-request-id'),
});
exports.env = (() => {
    // In production, require these. In development allow missing to keep scaffolding bootable.
    const parsed = EnvSchema.safeParse(process.env);
    if (parsed.success)
        return parsed.data;
    // If MONGODB_URI missing during scaffolding, provide a clearer message.
    // eslint-disable-next-line no-console
    console.error('Invalid environment variables:', parsed.error.flatten().fieldErrors);
    throw new Error('Environment validation failed');
})();
