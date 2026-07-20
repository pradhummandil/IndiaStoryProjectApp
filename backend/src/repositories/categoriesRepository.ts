import { prisma } from "../prisma/prismaClient";

export const categoriesRepository = {
  async getCategories() {
    // No dedicated Category model in schema; use Tag.
    // Keeping stable contract for mobile expecting categories.
    return prisma.tag.findMany({
      take: 100,
      orderBy: { createdAt: "desc" },
      select: { id: true, name: true, slug: true },
    });
  },
};
