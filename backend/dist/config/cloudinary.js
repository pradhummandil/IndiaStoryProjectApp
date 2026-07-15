"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.cloudinary = void 0;
exports.configureCloudinary = configureCloudinary;
const cloudinary_1 = require("cloudinary");
Object.defineProperty(exports, "cloudinary", { enumerable: true, get: function () { return cloudinary_1.v2; } });
const env_1 = require("./env");
const logger_1 = require("../core/logger/logger");
function configureCloudinary() {
    if (!env_1.env.CLOUDINARY_ENABLED)
        return;
    if (!env_1.env.CLOUDINARY_CLOUD_NAME || !env_1.env.CLOUDINARY_API_KEY || !env_1.env.CLOUDINARY_API_SECRET) {
        logger_1.logger.warn('Cloudinary is enabled but missing credentials. Uploads will fail until configured.', {
            enabled: env_1.env.CLOUDINARY_ENABLED,
        });
        return;
    }
    cloudinary_1.v2.config({
        cloud_name: env_1.env.CLOUDINARY_CLOUD_NAME,
        api_key: env_1.env.CLOUDINARY_API_KEY,
        api_secret: env_1.env.CLOUDINARY_API_SECRET,
    });
    logger_1.logger.info('Cloudinary configured');
}
