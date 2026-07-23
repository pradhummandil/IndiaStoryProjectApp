# Production Readiness Plan

## Issues Found During Codebase Audit

### 🔴 CRITICAL BUGS (Will cause runtime failures)

#### Backend

1. **bookmarksController.ts** — `addBookmark` reads `storyId` from `req.body` but the route defines it as path param `/:storyId`. Should read from `req.params.storyId`.
2. **bookmarksRepository.ts** — Uses `crypto.randomUUID()` but never imports `crypto`.
3. **searchRepository.ts** — Uses `crypto.randomUUID()` but never imports `crypto`.
4. **profileController.ts** — `getProfile()` calls repository with `null` BEFORE the null check; the `if (!userId)` check is after the DB call.
5. **All sensitive routes** (bookmarks, search, notifications, history, profile) — Missing `authenticate` middleware, relying only on manual `req.user?.id` checks which will always be null.

#### Flutter

6. **search_screen.dart** — `_ResultsSection` casts items with `item is Map<String, dynamic>` which will fail at runtime since the API returns objects, not raw Maps.
7. **splash_screen.dart** — Uses `AnimatedBuilder` widget name which may not exist; should be `AnimatedBuilder` (checking: correct name is `AnimatedBuilder` available in Flutter 3.10+).

### 🟡 MODERATE ISSUES

#### Backend

8. **auth middleware (auth.ts)** — The `authenticate` middleware fallback creates user with `id: uid` (Firebase UID), while `authController.login()` uses `crypto.randomUUID()`. Inconsistent ID generation.
9. **homeRepository.ts** — Uses `"Published" as any` string everywhere instead of the Prisma-generated `StoryStatus` enum values.

#### Flutter

10. **All routes missing auth** — `bookmarks_route.dart`, `search_route.dart`, etc. don't use the `authenticate` middleware.
11. **Layout issue in login_screen.dart** — `_SocialRow` uses `GridView.count(shrinkWrap: true)` inside a Column which will cause unbounded height errors.
12. **Login screen** — After calling `signInWithEmailPassword`, the navigation to `/home` may happen before state is fully updated.

### 🟢 MINOR ISSUES / CLEANUP

13. **Environment URLs** — API constants point to production (Render) correctly, but no easy way to switch to local dev.
14. **Error handling** — Backend error responses use `error` key, Flutter expects various formats.
15. **Android package** — Already fixed per TODO.md.

## Fix Plan

### Phase 1: Fix Critical Backend Bugs
- Add `crypto` import to `bookmarksRepository.ts` and `searchRepository.ts`
- Fix `bookmarksController.ts` to read `storyId` from `req.params`
- Fix `profileController.ts` null check order
- Add `authenticate` middleware to all protected routes

### Phase 2: Fix Critical Flutter Bugs
- Fix `search_screen.dart` type casting in `_ResultsSection`
- Fix `splash_screen.dart` `AnimatedBuilder` usage

### Phase 3: Fix Moderate Issues
- Fix auth middleware user ID inconsistency
- Fix layout issues in login screen
- Fix route protection consistency

### Phase 4: Build & Verify
- Run `flutter analyze` and fix remaining issues
- Run `tsc --noEmit` and fix type errors
- Verify production backend connectivity

