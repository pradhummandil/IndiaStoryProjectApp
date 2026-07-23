import type { Request, Response, NextFunction } from "express";
import admin from "firebase-admin";
import jwt from "jsonwebtoken";
import { prisma } from "../../prisma/prismaClient";
import { env } from "../../config/env";
import { UnauthorizedError } from "../errors/apiErrors";

// Extend Express Request
declare global {
  namespace Express {
    interface Request {
      user?: {
        id: string;
        uid: string;
        email: string;
        name: string;
        role: string;
      };
    }
  }
}

const JWT_SECRET =
  env.JWT_SECRET || process.env.JWT_SECRET || "isp-jwt-secret-dev";
const JWT_EXPIRES_IN = "7d";

function getFirebaseApp(): admin.app.App | null {
  if (admin.apps.length > 0) return admin.apps[0]!;
  if (!env.FIREBASE_ENABLED) return null;

  const serviceAccountBase64 =
    env.FIREBASE_SERVICE_ACCOUNT_JSON ||
    process.env.FIREBASE_SERVICE_ACCOUNT_JSON;
  if (serviceAccountBase64) {
    try {
      const serviceAccount = JSON.parse(
        Buffer.from(serviceAccountBase64, "base64").toString("utf-8"),
      );
      return admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
      });
    } catch {
      // Fall through
    }
  }
  try {
    return admin.initializeApp({
      projectId:
        env.FIREBASE_PROJECT_ID ||
        process.env.FIREBASE_PROJECT_ID ||
        "indiastoryproject",
    });
  } catch {
    return null;
  }
}

let firebaseApp: admin.app.App | null = null;
function getAdmin(): admin.app.App | null {
  if (!firebaseApp) firebaseApp = getFirebaseApp();
  return firebaseApp;
}

/** Verify Firebase ID Token from Authorization header */
export async function verifyFirebaseToken(token: string) {
  const app = getAdmin();
  if (!app) return null;
  try {
    const decoded = await app.auth().verifyIdToken(token);
    return decoded;
  } catch {
    return null;
  }
}

/** Issue a short-lived JWT for internal API calls */
export function issueJWT(payload: {
  userId: string;
  uid: string;
  role: string;
}): string {
  return jwt.sign(payload, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN });
}

/** Verify internal JWT */
export function verifyJWT(
  token: string,
): { userId: string; uid: string; role: string } | null {
  try {
    return jwt.verify(token, JWT_SECRET) as any;
  } catch {
    return null;
  }
}

/** Middleware: authenticate via Firebase ID Token or internal JWT */
export async function authenticate(
  req: Request,
  _res: Response,
  next: NextFunction,
) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return next(
      new UnauthorizedError("Missing or invalid Authorization header"),
    );
  }

  const token = authHeader.substring(7);

  // First try internal JWT
  const jwtPayload = verifyJWT(token);
  if (jwtPayload) {
    const user = await prisma.userProfile.findUnique({
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
    return next(new UnauthorizedError("Invalid or expired token"));
  }

  // Upsert UserProfile
  const uid = firebasePayload.uid;
  const email = firebasePayload.email || "";
  const name = firebasePayload.name || firebasePayload.displayName || "";

  const user = await prisma.userProfile.upsert({
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
export async function optionalAuth(
  req: Request,
  _res: Response,
  next: NextFunction,
) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return next();
  }

  const token = authHeader.substring(7);

  // Try internal JWT first
  const jwtPayload = verifyJWT(token);
  if (jwtPayload) {
    const user = await prisma.userProfile.findUnique({
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
      const user = await prisma.userProfile.upsert({
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
    } catch {
      // Silently skip auth if DB fails
    }
  }

  next();
}

export { JWT_SECRET };
