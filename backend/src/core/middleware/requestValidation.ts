import type { Express } from 'express';

// Request validation structure only.
// In future, this will host express-validator / zod schemas per route.
export function applyRequestValidation(_app: Express): void {
  // No-op in scaffolding.
}

