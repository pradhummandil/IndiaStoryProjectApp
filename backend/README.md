# India Story Project Backend (Foundation)

Production-ready backend architecture foundation.

## What exists
- Express app initialization with production middleware
- Environment validation (zod + dotenv)
- Logger setup (winston + morgan stream)
- MongoDB connection helper (no models)
- Cloudinary configuration (no upload endpoints)
- Firebase Admin configuration (no auth)
- Socket.IO bootstrap (no events)
- Global error handling + async wrapper
- Health check endpoint: `GET /health`

## What does NOT exist (by design for this milestone)
- No feature routes
- No controllers
- No authentication
- No MongoDB models

## Development
1. Copy `.env.example` to `.env`
2. Install: `npm install`
3. Run: `npm run dev`

## Production
1. Build: `npm run build`
2. Start: `npm run start`

