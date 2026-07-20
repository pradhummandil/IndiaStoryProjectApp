import { Router } from "express";

import { homeRouter } from "./home";
import { storiesRouter } from "./stories";
import { categoriesRouter } from "./categories";
import { profileRouter } from "./profile";
import { writerRouter } from "./writer";
import { aiAssistantRouter } from "./aiAssistant";
import { publishRouter } from "./publish";

export const apiRouter = Router();

apiRouter.use("/home", homeRouter);
apiRouter.use("/stories", storiesRouter);
apiRouter.use("/categories", categoriesRouter);
apiRouter.use("/profile", profileRouter);
apiRouter.use("/writer", writerRouter);
apiRouter.use("/writer/assistant", aiAssistantRouter);
apiRouter.use("/writer/publish", publishRouter);
