"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createSocketServer = createSocketServer;
const socket_io_1 = require("socket.io");
const env_1 = require("../config/env");
const logger_1 = require("../core/logger/logger");
function createSocketServer(httpServer) {
    const io = new socket_io_1.Server(httpServer, {
        cors: {
            origin: env_1.env.SOCKET_IO_CORS_ORIGIN,
            credentials: true,
        },
    });
    io.on('connection', (socket) => {
        logger_1.logger.info('Socket connected', { socketId: socket.id });
        socket.on('disconnect', () => {
            logger_1.logger.info('Socket disconnected', { socketId: socket.id });
        });
    });
    return io;
}
