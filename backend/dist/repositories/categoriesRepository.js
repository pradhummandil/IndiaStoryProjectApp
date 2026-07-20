"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.categoriesRepository = void 0;
const prismaClient_1 = require("../prisma/prismaClient");
exports.categoriesRepository = {
    async getCategories() {
        // No dedicated Category model in schema; use Tag.
        // Keeping stable contract for mobile expecting categories.
        return prismaClient_1.prisma.tag.findMany({
            take: 100,
            orderBy: { createdAt: "desc" },
            select: { id: true, name: true, slug: true },
        });
    },
};
