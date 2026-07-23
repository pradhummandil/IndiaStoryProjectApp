import { authRepository } from "../../repositories/authRepository";
import { issueJWT } from "../../core/middleware/auth";
import {
  BadRequestError,
  UnauthorizedError,
} from "../../core/errors/apiErrors";

export const authController = {
  /**
   * POST /api/auth/login
   * Verify Firebase ID token, upsert UserProfile, return JWT
   */
  async login(req: any) {
    const { idToken } = req.body ?? {};
    if (!idToken) throw new BadRequestError("idToken is required");

    // Import firebase-admin dynamically to avoid circular deps
    const admin = await import("firebase-admin");
    const firebaseApp = admin.apps[0];
    if (!firebaseApp) throw new BadRequestError("Firebase not initialized");

    let decoded;
    try {
      decoded = await admin.auth().verifyIdToken(idToken);
    } catch {
      throw new UnauthorizedError("Invalid Firebase ID token");
    }

    const firebaseUser = {
      uid: decoded.uid,
      email: decoded.email || "",
      name: decoded.name || decoded.displayName || undefined,
      photoURL: decoded.picture || decoded.photoURL || undefined,
    };

    if (!firebaseUser.email) {
      throw new BadRequestError("Email is required from Firebase");
    }

    const user = await authRepository.upsertUserProfile(firebaseUser);

    const jwt = issueJWT({
      userId: user.id,
      uid: decoded.uid,
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
  async getMe(req: any) {
    const userId = req.user?.id;
    if (!userId) throw new UnauthorizedError("Not authenticated");

    const user = await authRepository.getUserById(userId);
    if (!user) throw new UnauthorizedError("User not found");

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
  async register(req: any) {
    const { idToken, name } = req.body ?? {};
    if (!idToken) throw new BadRequestError("idToken is required");

    const admin = await import("firebase-admin");
    const firebaseApp = admin.apps[0];
    if (!firebaseApp) throw new BadRequestError("Firebase not initialized");

    let decoded;
    try {
      decoded = await admin.auth().verifyIdToken(idToken);
    } catch {
      throw new UnauthorizedError("Invalid Firebase ID token");
    }

    const firebaseUser = {
      uid: decoded.uid,
      email: decoded.email || "",
      name: name || decoded.name || decoded.displayName || undefined,
      photoURL: decoded.picture || decoded.photoURL || undefined,
    };

    if (!firebaseUser.email) {
      throw new BadRequestError("Email is required from Firebase");
    }

    const user = await authRepository.upsertUserProfile(firebaseUser);

    const jwt = issueJWT({
      userId: user.id,
      uid: decoded.uid,
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
   * POST /api/auth/refresh
   * Issue a new JWT for an already-authenticated user.
   */
  async refreshToken(req: any) {
    const userId = req.user?.id;
    const uid = req.user?.uid;
    const role = req.user?.role;
    if (!userId || !uid) throw new UnauthorizedError("Not authenticated");

    const jwt = issueJWT({ userId, uid, role });
    return { token: jwt };
  },

  /**
   * POST /api/auth/logout
   * Server-side logout (no-op for JWT, client clears token).
   * Future: add token blacklist if needed.
   */
  async logout(req: any) {
    return { success: true };
  },
};
