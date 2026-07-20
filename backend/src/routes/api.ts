import { Router } from "express";

import { homeRouter } from "./home";
import { storiesRouter } from "./stories";
import { categoriesRouter } from "./categories";
import { profileRouter } from "./profile";

export const apiRouter = Router();

apiRouter.use("/home", homeRouter);
apiRouter.use("/stories", storiesRouter);
apiRouter.use("/categories", categoriesRouter);
apiRouter.use("/profile", profileRouter);
