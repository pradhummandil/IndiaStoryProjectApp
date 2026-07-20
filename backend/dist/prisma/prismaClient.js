"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.prisma = void 0;
const client_1 = require("@prisma/client");
// Singleton Prisma client for the app runtime.
// (Avoid creating multiple instances during dev hot-reload.)
const globalForPrisma = globalThis;
exports.prisma = globalForPrisma.prisma ??
    new client_1.PrismaClient({
    // Prisma logging can be enabled via PRISMA_LOG_LEVEL if desired.
    });
if (process.env.NODE_ENV !== "production")
    globalForPrisma.prisma = exports.prisma;
