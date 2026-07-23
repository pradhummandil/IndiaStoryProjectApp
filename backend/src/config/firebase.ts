import admin from "firebase-admin";

import { env } from "./env";
import { logger } from "../core/logger/logger";

export function configureFirebaseAdmin(): void {
  if (!env.FIREBASE_ENABLED) {
    logger.info("Firebase Admin disabled");
    return;
  }

  const raw = env.FIREBASE_SERVICE_ACCOUNT_JSON;
  if (!raw || raw.trim() === "") {
    logger.info("Firebase Admin disabled (no service account JSON provided)");
    return;
  }

  try {
    const serviceAccount = JSON.parse(raw);

    // firebase-admin's TS types differ slightly across versions; keep scaffolding robust.
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const credential = (admin as any).credential?.cert?.(serviceAccount);

    admin.initializeApp({
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      credential: credential as any,
    });

    logger.info("Firebase Admin configured");
  } catch (err) {
    logger.warn(
      "Firebase Admin initialization failed (continuing without Firebase)",
      {
        error: (err as Error).message,
      },
    );
  }
}

export { admin };
