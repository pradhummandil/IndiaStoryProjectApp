import { v2 as cloudinary } from "cloudinary";

import { env } from "./env";
import { logger } from "../core/logger/logger";

export function configureCloudinary(): void {
  if (!env.CLOUDINARY_ENABLED) {
    logger.info("Cloudinary disabled");
    return;
  }

  if (
    !env.CLOUDINARY_CLOUD_NAME ||
    !env.CLOUDINARY_API_KEY ||
    !env.CLOUDINARY_API_SECRET
  ) {
    logger.info("Cloudinary disabled (missing credentials)");
    return;
  }

  cloudinary.config({
    cloud_name: env.CLOUDINARY_CLOUD_NAME,
    api_key: env.CLOUDINARY_API_KEY,
    api_secret: env.CLOUDINARY_API_SECRET,
  });

  logger.info("Cloudinary configured");
}

export { cloudinary };
