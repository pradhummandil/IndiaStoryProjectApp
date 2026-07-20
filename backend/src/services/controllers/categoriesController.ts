import { categoriesRepository } from "../../repositories/categoriesRepository";

export const categoriesController = {
  async getCategories() {
    return categoriesRepository.getCategories();
  },
};
