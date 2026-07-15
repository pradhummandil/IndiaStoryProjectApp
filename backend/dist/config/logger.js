"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.logger = exports.httpLoggerStream = void 0;
exports.configureLogger = configureLogger;
const winston_1 = require("winston");
const env_1 = require("./env");
exports.httpLoggerStream = {
    write(message) {
        exports.logger.http(message.trim());
    },
};
exports.logger = (0, winston_1.createLogger)({
    level: env_1.env.NODE_ENV === 'production' ? 'info' : 'debug',
    format: winston_1.format.combine(winston_1.format.timestamp(), winston_1.format.errors({ stack: true }), winston_1.format.json()),
    transports: [new winston_1.transports.Console()],
});
// Ensure morgan 'http' exists.
exports.logger.http = (msg) => exports.logger.info(msg);
function configureLogger() {
    // No-op for now; logger is created eagerly.
}
