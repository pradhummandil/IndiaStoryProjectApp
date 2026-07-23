import { Router } from "express";

import { homeRouter } from "./home";
import { storiesRouter } from "./stories";
import { categoriesRouter } from "./categories";
import { profileRouter } from "./profile";
import { writerRouter } from "./writer";
import { aiAssistantRouter } from "./aiAssistant";
import { publishRouter } from "./publish";
import { bookmarksRouter } from "./bookmarks";
import { searchRouter } from "./search";
import { notificationsRouter } from "./notifications";
import { historyRouter } from "./history";
import { authRouter } from "./auth";

export const apiRouter = Router();

apiRouter.use("/home", homeRouter);
apiRouter.use("/stories", storiesRouter);
apiRouter.use("/categories", categoriesRouter);
apiRouter.use("/profile", profileRouter);
apiRouter.use("/writer", writerRouter);
apiRouter.use("/writer/assistant", aiAssistantRouter);
apiRouter.use("/writer/publish", publishRouter);
apiRouter.use("/bookmarks", bookmarksRouter);
apiRouter.use("/search", searchRouter);
apiRouter.use("/notifications", notificationsRouter);
apiRouter.use("/history", historyRouter);
apiRouter.use("/auth", authRouter);
