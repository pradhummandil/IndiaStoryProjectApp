import { Server as SocketIOServer, type Socket } from 'socket.io';
import { type Server as HttpServer } from 'http';

import { env } from '../config/env';
import { logger } from '../core/logger/logger';

export function createSocketServer(httpServer: HttpServer): SocketIOServer {
  const io = new SocketIOServer(httpServer, {
    cors: {
      origin: env.SOCKET_IO_CORS_ORIGIN,
      credentials: true,
    },
  });

  io.on('connection', (socket: Socket) => {
    logger.info('Socket connected', { socketId: socket.id });

    socket.on('disconnect', () => {
      logger.info('Socket disconnected', { socketId: socket.id });
    });
  });

  return io;
}

