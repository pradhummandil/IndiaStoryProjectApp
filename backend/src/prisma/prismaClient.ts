import { PrismaClient } from "@prisma/client";

// Singleton Prisma client for the app runtime.
// (Avoid creating multiple instances during dev hot-reload.)
const globalForPrisma = globalThis as unknown as { prisma?: PrismaClient };

export const prisma =
  globalForPrisma.prisma ??
  new PrismaClient({
    // Prisma logging can be enabled via PRISMA_LOG_LEVEL if desired.
  });

if (process.env.NODE_ENV !== "production") globalForPrisma.prisma = prisma;
