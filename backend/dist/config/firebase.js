"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.admin = void 0;
exports.configureFirebaseAdmin = configureFirebaseAdmin;
const firebase_admin_1 = __importDefault(require("firebase-admin"));
exports.admin = firebase_admin_1.default;
const env_1 = require("./env");
const logger_1 = require("../core/logger/logger");
function configureFirebaseAdmin() {
    if (!env_1.env.FIREBASE_ENABLED) {
        logger_1.logger.info("Firebase Admin disabled");
        return;
    }
    const raw = env_1.env.FIREBASE_SERVICE_ACCOUNT_JSON;
    if (!raw || raw.trim() === "") {
        logger_1.logger.info("Firebase Admin disabled (no service account JSON provided)");
        return;
    }
    try {
        const serviceAccount = JSON.parse(raw);
        // firebase-admin's TS types differ slightly across versions; keep scaffolding robust.
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const credential = firebase_admin_1.default.credential?.cert?.(serviceAccount);
        firebase_admin_1.default.initializeApp({
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            credential: credential,
        });
        logger_1.logger.info("Firebase Admin configured");
    }
    catch (err) {
        logger_1.logger.warn("Firebase Admin initialization failed (continuing without Firebase)", {
            error: err.message,
        });
    }
}
