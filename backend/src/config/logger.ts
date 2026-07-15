import { createLogger, format, transports } from 'winston';
import { env } from './env';

export const httpLoggerStream = {
  write(message: string) {
    logger.http(message.trim());
  },
};

export const logger = createLogger({
  level: env.NODE_ENV === 'production' ? 'info' : 'debug',
  format: format.combine(
    format.timestamp(),
    format.errors({ stack: true }),
    format.json(),
  ),
  transports: [new transports.Console()],
});

// Ensure morgan 'http' exists.
(logger as any).http = (msg: string) => logger.info(msg);

export function configureLogger(): void {
  // No-op for now; logger is created eagerly.
}

