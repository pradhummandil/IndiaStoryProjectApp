"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.storiesController = void 0;
const storiesRepository_1 = require("../../repositories/storiesRepository");
const apiErrors_1 = require("../../core/errors/apiErrors");
exports.storiesController = {
    async getStories(req) {
        const { page, limit, category, region, language, search, sorting } = req.query ?? {};
        return storiesRepository_1.storiesRepository.getStories({
            page,
            limit,
            category,
            region,
            language,
            search,
            sort: sorting,
        });
    },
    async getStoryBySlug(req) {
        const slug = String(req.params.slug ?? "");
        if (!slug)
            throw new apiErrors_1.BadRequestError("slug is required");
        const data = await storiesRepository_1.storiesRepository.getStoryBySlug(slug);
        if (!data)
            throw new apiErrors_1.NotFoundError("Story not found");
        return data;
    },
};
