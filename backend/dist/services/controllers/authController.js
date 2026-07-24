"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.authController = void 0;
const logger_1 = require("../../core/logger/logger");
const authRepository_1 = require("../../repositories/authRepository");
const auth_1 = require("../../core/middleware/auth");
const apiErrors_1 = require("../../core/errors/apiErrors");
exports.authController = {
    /**
     * POST /api/auth/login
     * Accepts a Firebase ID token, verifies it, upserts user in DB, returns JWT.
     *
     * The Flutter app sends the Firebase ID token from the client-side Firebase SDK.
     * This endpoint verifies it using Firebase Admin SDK, creates/updates the user
     * in our database, and returns a JWT for subsequent API calls.
     */
    async login(req) {
        const stepLog = (step, data) => {
            logger_1.logger.info(`[authController.login] ${step}`, data || {});
        };
        stepLog("STEP 1: Request received", {
            hasBody: !!req.body,
            contentType: req.headers?.["content-type"],
        });
        // ─── Parse request body ──────────────────────────────────────
        const { idToken } = req.body ?? {};
        if (!idToken) {
            stepLog("STEP 1b: Missing idToken in body");
            throw new apiErrors_1.BadRequestError("idToken is required");
        }
        stepLog("STEP 1c: idToken present", {
            tokenLength: idToken.length,
            tokenPreview: idToken.substring(0, 20) + "...",
        });
        // ─── Import firebase-admin and check initialization ──────────
        stepLog("STEP 2: Loading firebase-admin");
        let admin;
        try {
            admin = await import("firebase-admin");
            stepLog("STEP 2b: firebase-admin loaded", {
                appsCount: admin.apps?.length ?? 0,
            });
        }
        catch (err) {
            stepLog("STEP 2b: firebase-admin import FAILED", {
                error: err.message,
            });
            throw new apiErrors_1.InternalServerError("Firebase Admin SDK not available in this environment");
        }
        // Check if Firebase is initialized by checking apps
        const firebaseApp = admin.apps?.[0] ?? null;
        if (!firebaseApp) {
            stepLog("STEP 2c: Firebase not initialized — trying verifyFirebaseToken directly");
            // Try the verifyFirebaseToken utility from auth middleware which
            // handles lazy initialization
            const decoded = await (0, auth_1.verifyFirebaseToken)(idToken);
            if (!decoded) {
                stepLog("STEP 2d: Firebase token verification failed (Firebase not available)");
                throw new apiErrors_1.UnauthorizedError("Firebase authentication is not configured on the server. " +
                    "Please ensure Firebase Admin is set up or use email/password login.");
            }
            stepLog("STEP 2e: Token verified via verifyFirebaseToken fallback", {
                uid: decoded.uid,
                email: decoded.email,
            });
            // ─── Process verified user ──────────────────────────────
            return await this.processVerifiedUser({
                uid: decoded.uid,
                email: decoded.email || "",
                name: decoded.name || decoded.displayName || undefined,
                photoURL: decoded.picture || decoded.photoURL || undefined,
            }, stepLog);
        }
        // ─── Verify Firebase ID Token ──────────────────────────────────
        stepLog("STEP 3: Verifying Firebase ID token");
        let decoded;
        try {
            decoded = await admin.auth().verifyIdToken(idToken);
            stepLog("STEP 3b: Token verified successfully", {
                uid: decoded.uid,
                email: decoded.email,
                issuer: decoded.iss,
                issuedAt: new Date(decoded.iat * 1000).toISOString(),
                expiresAt: new Date(decoded.exp * 1000).toISOString(),
            });
        }
        catch (err) {
            stepLog("STEP 3b: Token verification FAILED", {
                errorName: err?.name,
                errorMessage: err?.message,
                errorCode: err?.code,
            });
            throw new apiErrors_1.UnauthorizedError("Invalid Firebase ID token");
        }
        // ─── Extract user info from decoded token ─────────────────────
        stepLog("STEP 4: Extracting user info from decoded token");
        if (!decoded.email) {
            stepLog("STEP 4c: Email missing from Firebase token");
            throw new apiErrors_1.BadRequestError("Email is required from Firebase");
        }
        // ─── Upsert user in database ──────────────────────────────────
        return await this.processVerifiedUser({
            uid: decoded.uid,
            email: decoded.email,
            name: decoded.name || decoded.displayName || undefined,
            photoURL: decoded.picture || decoded.photoURL || undefined,
        }, stepLog);
    },
    /**
     * Shared logic: after Firebase verification, upsert user and return JWT.
     */
    async processVerifiedUser(firebaseUser, stepLog) {
        stepLog("STEP 5: Upserting user profile in database", {
            uid: firebaseUser.uid,
            email: firebaseUser.email,
        });
        let user;
        try {
            user = await authRepository_1.authRepository.upsertUserProfile(firebaseUser);
            stepLog("STEP 5b: User upserted successfully", {
                userId: user.id,
                email: user.email,
                role: user.role,
            });
        }
        catch (err) {
            stepLog("STEP 5b: User upsert FAILED", {
                errorName: err?.name,
                errorMessage: err?.message,
                errorCode: err?.code,
            });
            throw new apiErrors_1.InternalServerError("Failed to create/update user profile");
        }
        // ─── Generate JWT ────────────────────────────────────────────
        stepLog("STEP 6: Generating JWT", {
            userId: user.id,
            uid: firebaseUser.uid,
            role: user.role,
        });
        let jwt;
        try {
            jwt = (0, auth_1.issueJWT)({
                userId: user.id,
                uid: firebaseUser.uid,
                role: user.role,
            });
            stepLog("STEP 6b: JWT generated", {
                tokenLength: jwt.length,
                tokenPreview: jwt.substring(0, 20) + "...",
            });
        }
        catch (err) {
            stepLog("STEP 6b: JWT generation FAILED", {
                errorName: err?.name,
                errorMessage: err?.message,
            });
            throw new apiErrors_1.InternalServerError("Failed to generate authentication token");
        }
        // ─── Return response ─────────────────────────────────────────
        stepLog("STEP 7: Sending response", {
            userId: user.id,
            email: user.email,
            role: user.role,
        });
        return {
            token: jwt,
            user: {
                id: user.id,
                email: user.email,
                name: user.name,
                avatarUrl: user.avatarUrl,
                role: user.role,
            },
        };
    },
    /**
     * GET /api/auth/me
     * Return authenticated user profile
     */
    async getMe(req) {
        const userId = req.user?.id;
        if (!userId)
            throw new apiErrors_1.UnauthorizedError("Not authenticated");
        const user = await authRepository_1.authRepository.getUserById(userId);
        if (!user)
            throw new apiErrors_1.UnauthorizedError("User not found");
        return {
            id: user.id,
            email: user.email,
            name: user.name,
            avatarUrl: user.avatarUrl,
            bio: user.bio,
            role: user.role,
            level: user.level,
            totalXP: user.totalXP,
            readingStreak: user.readingStreak,
            createdAt: user.createdAt,
        };
    },
    /**
     * POST /api/auth/register
     * Verify Firebase ID token, create/upsert UserProfile, return JWT.
     * Accepts optional name field in body to set display name.
     */
    async register(req) {
        const stepLog = (step, data) => {
            logger_1.logger.info(`[authController.register] ${step}`, data || {});
        };
        stepLog("STEP 1: Register request received");
        const { idToken, name } = req.body ?? {};
        if (!idToken)
            throw new apiErrors_1.BadRequestError("idToken is required");
        stepLog("STEP 2: Loading firebase-admin");
        let decoded;
        try {
            const admin = await import("firebase-admin");
            const firebaseApp = admin.apps?.[0] ?? null;
            if (firebaseApp) {
                decoded = await admin.auth().verifyIdToken(idToken);
            }
        }
        catch {
            // Fall through to fallback
        }
        if (!decoded) {
            stepLog("STEP 3: Trying verifyFirebaseToken fallback");
            const fbDecoded = await (0, auth_1.verifyFirebaseToken)(idToken);
            if (!fbDecoded) {
                throw new apiErrors_1.UnauthorizedError("Firebase authentication not configured on server");
            }
            stepLog("STEP 3b: Token verified via fallback", { uid: fbDecoded.uid });
            const firebaseUser = {
                uid: fbDecoded.uid,
                email: fbDecoded.email || "",
                name: name || fbDecoded.name || fbDecoded.displayName || undefined,
                photoURL: fbDecoded.picture || fbDecoded.photoURL || undefined,
            };
            if (!firebaseUser.email) {
                throw new apiErrors_1.BadRequestError("Email is required from Firebase");
            }
            return await this.processVerifiedUser(firebaseUser, stepLog);
        }
        const firebaseUser = {
            uid: decoded.uid,
            email: decoded.email || "",
            name: name || decoded.name || decoded.displayName || undefined,
            photoURL: decoded.picture || decoded.photoURL || undefined,
        };
        if (!firebaseUser.email) {
            throw new apiErrors_1.BadRequestError("Email is required from Firebase");
        }
        return await this.processVerifiedUser(firebaseUser, stepLog);
    },
    /**
     * POST /api/auth/refresh
     * Issue a new JWT for an already-authenticated user.
     */
    async refreshToken(req) {
        const userId = req.user?.id;
        const uid = req.user?.uid;
        const role = req.user?.role;
        if (!userId || !uid)
            throw new apiErrors_1.UnauthorizedError("Not authenticated");
        const jwt = (0, auth_1.issueJWT)({ userId, uid, role });
        return { token: jwt };
    },
    /**
     * POST /api/auth/logout
     * Server-side logout (no-op for JWT, client clears token).
     * Future: add token blacklist if needed.
     */
    async logout(req) {
        return { success: true };
    },
};
