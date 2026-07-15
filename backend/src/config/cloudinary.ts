import { v2 as cloudinary } from 'cloudinary';

import { env } from './env';
import { logger } from '../core/logger/logger';

export function configureCloudinary(): void {
  if (!env.CLOUDINARY_ENABLED) return;

  if (!env.CLOUDINARY_CLOUD_NAME || !env.CLOUDINARY_API_KEY || !env.CLOUDINARY_API_SECRET) {
    logger.warn('Cloudinary is enabled but missing credentials. Uploads will fail until configured.', {
      enabled: env.CLOUDINARY_ENABLED,
    });
    return;
  }

  cloudinary.config({
    cloud_name: env.CLOUDINARY_CLOUD_NAME,
    api_key: env.CLOUDINARY_API_KEY,
    api_secret: env.CLOUDINARY_API_SECRET,
  });

  logger.info('Cloudinary configured');
}

export { cloudinary };

