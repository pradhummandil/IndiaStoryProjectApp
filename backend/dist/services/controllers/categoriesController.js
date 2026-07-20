"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.categoriesController = void 0;
const categoriesRepository_1 = require("../../repositories/categoriesRepository");
exports.categoriesController = {
    async getCategories() {
        return categoriesRepository_1.categoriesRepository.getCategories();
    },
};
