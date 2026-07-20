import { storiesRepository } from "../../repositories/storiesRepository";
import { NotFoundError, BadRequestError } from "../../core/errors/apiErrors";

export const storiesController = {
  async getStories(req: any) {
    const { page, limit, category, region, language, search, sorting } =
      req.query ?? {};

    return storiesRepository.getStories({
      page,
      limit,
      category,
      region,
      language,
      search,
      sort: sorting,
    });
  },

  async getStoryBySlug(req: any) {
    const slug = String(req.params.slug ?? "");
    if (!slug) throw new BadRequestError("slug is required");

    const data = await storiesRepository.getStoryBySlug(slug);
    if (!data) throw new NotFoundError("Story not found");
    return data;
  },
};
