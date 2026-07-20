import { homeRepository } from "../../repositories/homeRepository";

export const homeController = {
  async getHome() {
    const data = await homeRepository.getHome();
    return data;
  },
};
