"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.homeController = void 0;
const homeRepository_1 = require("../../repositories/homeRepository");
exports.homeController = {
    async getHome() {
        const data = await homeRepository_1.homeRepository.getHome();
        return data;
    },
};
