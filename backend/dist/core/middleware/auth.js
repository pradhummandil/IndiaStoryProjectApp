"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.JWT_SECRET = void 0;
exports.verifyFirebaseToken = verifyFirebaseToken;
exports.issueJWT = issueJWT;
exports.verifyJWT = verifyJWT;
exports.authenticate = authenticate;
exports.optionalAuth = optionalAuth;
const firebase_admin_1 = __importDefault(require("firebase-admin"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const prismaClient_1 = require("../../prisma/prismaClient");
const apiErrors_1 = require("../errors/apiErrors");
const JWT_SECRET = process.env.JWT_SECRET || "isp-jwt-secret-dev";
exports.JWT_SECRET = JWT_SECRET;
const JWT_EXPIRES_IN = "7d";
function getFirebaseApp() {
    if (firebase_admin_1.default.apps.length > 0)
        return firebase_admin_1.default.apps[0];
    const serviceAccountBase64 = process.env.FIREBASE_SERVICE_ACCOUNT_JSON;
    if (serviceAccountBase64) {
        const serviceAccount = JSON.parse(Buffer.from(serviceAccountBase64, "base64").toString("utf-8"));
        return firebase_admin_1.default.initializeApp({
            credential: firebase_admin_1.default.credential.cert(serviceAccount),
        });
    }
    try {
        return firebase_admin_1.default.initializeApp({
            projectId: process.env.FIREBASE_PROJECT_ID || "indiastoryproject",
        });
    }
    catch {
        return firebase_admin_1.default.apps[0];
    }
}
let firebaseApp = null;
function getAdmin() {
    if (!firebaseApp)
        firebaseApp = getFirebaseApp();
    return firebaseApp;
}
/** Verify Firebase ID Token from Authorization header */
async function verifyFirebaseToken(token) {
    try {
        const decoded = await getAdmin().auth().verifyIdToken(token);
        return decoded;
    }
    catch {
        return null;
    }
}
/** Issue a short-lived JWT for internal API calls */
function issueJWT(payload) {
    return jsonwebtoken_1.default.sign(payload, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN });
}
/** Verify internal JWT */
function verifyJWT(token) {
    try {
        return jsonwebtoken_1.default.verify(token, JWT_SECRET);
    }
    catch {
        return null;
    }
}
/** Middleware: authenticate via Firebase ID Token or internal JWT */
async function authenticate(req, _res, next) {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        return next(new apiErrors_1.UnauthorizedError("Missing or invalid Authorization header"));
    }
    const token = authHeader.substring(7);
    // First try internal JWT
    const jwtPayload = verifyJWT(token);
    if (jwtPayload) {
        const user = await prismaClient_1.prisma.userProfile.findUnique({
            where: { id: jwtPayload.userId },
        });
        if (user) {
            req.user = {
                id: user.id,
                uid: jwtPayload.uid,
                email: user.email,
                name: user.name || "",
                role: user.role,
            };
            return next();
        }
    }
    // Fallback: verify Firebase ID Token
    const firebasePayload = await verifyFirebaseToken(token);
    if (!firebasePayload) {
        return next(new apiErrors_1.UnauthorizedError("Invalid or expired token"));
    }
    // Upsert UserProfile
    const uid = firebasePayload.uid;
    const email = firebasePayload.email || "";
    const name = firebasePayload.name || firebasePayload.displayName || "";
    const user = await prismaClient_1.prisma.userProfile.upsert({
        where: { email },
        update: { name: name || undefined, lastActiveAt: new Date() },
        create: {
            id: uid,
            email,
            name: name || email.split("@")[0],
            role: "Reader",
            updatedAt: new Date(),
        },
    });
    req.user = {
        id: user.id,
        uid,
        email: user.email,
        name: user.name || "",
        role: user.role,
    };
    next();
}
/** Optional auth — doesn't block if no token */
async function optionalAuth(req, _res, next) {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        return next();
    }
    const token = authHeader.substring(7);
    // Try internal JWT first
    const jwtPayload = verifyJWT(token);
    if (jwtPayload) {
        const user = await prismaClient_1.prisma.userProfile.findUnique({
            where: { id: jwtPayload.userId },
        });
        if (user) {
            req.user = {
                id: user.id,
                uid: jwtPayload.uid,
                email: user.email,
                name: user.name || "",
                role: user.role,
            };
        }
        return next();
    }
    // Fallback Firebase
    const firebasePayload = await verifyFirebaseToken(token);
    if (firebasePayload) {
        const uid = firebasePayload.uid;
        const email = firebasePayload.email || "";
        const name = firebasePayload.name || firebasePayload.displayName || "";
        try {
            const user = await prismaClient_1.prisma.userProfile.upsert({
                where: { email },
                update: { name: name || undefined, lastActiveAt: new Date() },
                create: {
                    id: uid,
                    email,
                    name: name || email.split("@")[0],
                    role: "Reader",
                    updatedAt: new Date(),
                },
            });
            req.user = {
                id: user.id,
                uid,
                email: user.email,
                name: user.name || "",
                role: user.role,
            };
        }
        catch {
            // Silently skip auth if DB fails
        }
    }
    next();
}
