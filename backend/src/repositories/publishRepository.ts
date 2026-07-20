import { prisma } from "../prisma/prismaClient";

export const publishRepository = {
  async getPublishReview(storyId: string, userId: string) {
    const story = await prisma.story.findFirst({
      where: { id: storyId, deleted: false },
      include: {
        Author: {
          select: { id: true, name: true, avatar: true, bio: true },
        },
        State: { select: { slug: true, name: true } },
        City: { select: { slug: true, name: true } },
        StoryTag: {
          take: 10,
          include: { Tag: { select: { id: true, name: true, slug: true } } },
        },
        StoryTheme: {
          take: 10,
          include: {
            Theme: { select: { id: true, name: true, slug: true } },
          },
        },
        StoryImage: {
          take: 5,
          orderBy: { sortOrder: "asc" },
          select: {
            imageUrl: true,
            sortOrder: true,
            caption: true,
            heroImage: true,
          },
        },
        StoryRevision: {
          take: 10,
          orderBy: { createdAt: "desc" },
          select: {
            id: true,
            title: true,
            version: true,
            createdAt: true,
            changedBy: true,
          },
        },
      },
    });

    if (!story) return null;

    // Compute SEO score
    let seoScore = 0;
    const seoChecks: { label: string; passed: boolean; message: string }[] = [];

    if (story.seoTitle && story.seoTitle.length > 10) {
      seoScore += 25;
      seoChecks.push({
        label: "SEO Title",
        passed: true,
        message: "Descriptive SEO title present",
      });
    } else {
      seoChecks.push({
        label: "SEO Title",
        passed: false,
        message: "Add a descriptive SEO title (minimum 10 characters)",
      });
    }

    if (story.seoDescription && story.seoDescription.length > 50) {
      seoScore += 25;
      seoChecks.push({
        label: "Meta Description",
        passed: true,
        message: "Meta description is well-calibrated",
      });
    } else {
      seoChecks.push({
        label: "Meta Description",
        passed: false,
        message: "Write an SEO meta description (50-160 characters)",
      });
    }

    if (story.StoryImage.length > 0) {
      seoScore += 20;
      seoChecks.push({
        label: "Images Tagged",
        passed: true,
        message: `${story.StoryImage.length} images have descriptive alt-text applied`,
      });
    } else {
      seoChecks.push({
        label: "Images Tagged",
        passed: false,
        message: "Add at least one hero image with alt text",
      });
    }

    if (story.StoryTag.length >= 2) {
      seoScore += 15;
      seoChecks.push({
        label: "Tags & Categories",
        passed: true,
        message: `${story.StoryTag.length} tags applied for content categorization`,
      });
    } else {
      seoChecks.push({
        label: "Tags & Categories",
        passed: false,
        message: "Add at least 2 tags for better discoverability",
      });
    }

    if (story.excerpt && story.excerpt.length > 80) {
      seoScore += 15;
      seoChecks.push({
        label: "Story Excerpt",
        passed: true,
        message: "Compelling excerpt for better search visibility",
      });
    } else {
      seoChecks.push({
        label: "Story Excerpt",
        passed: false,
        message: "Add a compelling story excerpt (80+ characters recommended)",
      });
    }

    // Build version history from revisions
    const versionHistory = story.StoryRevision.map((rev) => ({
      id: rev.id,
      title: rev.title,
      version: rev.version,
      createdAt: rev.createdAt,
      changedBy: rev.changedBy,
    }));

    // Build related stories (same state or shared tags)
    const tagIds = story.StoryTag.map((st) => st.tagId);
    const relatedStories = await prisma.story.findMany({
      where: {
        id: { not: story.id },
        deleted: false,
        status: "Published" as any,
        OR: [
          { stateId: story.stateId },
          ...(tagIds.length > 0
            ? [{ StoryTag: { some: { tagId: { in: tagIds } } } }]
            : []),
        ],
      },
      take: 4,
      orderBy: { publishedAt: "desc" },
      select: {
        id: true,
        slug: true,
        title: true,
        excerpt: true,
        readingTime: true,
        Author: { select: { name: true, avatar: true } },
      },
    });

    return {
      story: {
        id: story.id,
        slug: story.slug,
        title: story.title,
        excerpt: story.excerpt,
        content: story.content?.substring(0, 500),
        readingTime: story.readingTime,
        status: story.status,
        publishedAt: story.publishedAt,
        seoTitle: story.seoTitle,
        seoDescription: story.seoDescription,
        seoKeywords: story.seoKeywords,
        viewCount: story.viewCount,
        createdAt: story.createdAt,
        updatedAt: story.updatedAt,
      },
      author: story.Author,
      category: {
        state: story.State,
        city: story.City,
      },
      images: story.StoryImage,
      tags: story.StoryTag.map((st) => st.Tag),
      themes: story.StoryTheme.map((st) => st.Theme),
      seo: {
        score: seoScore,
        checks: seoChecks,
        passedCount: seoChecks.filter((c) => c.passed).length,
        totalCount: seoChecks.length,
      },
      versionHistory,
      relatedStories,
    };
  },

  async validateForPublish(storyId: string, userId: string) {
    const story = await prisma.story.findFirst({
      where: { id: storyId, deleted: false },
      include: {
        StoryImage: { take: 1 },
        StoryTag: { take: 1 },
      },
    });

    if (!story) return { valid: false, errors: ["Story not found"] };

    const errors: string[] = [];
    const warnings: string[] = [];

    if (!story.title || story.title.trim().length < 3) {
      errors.push("Story title is required (minimum 3 characters)");
    }

    if (!story.excerpt || story.excerpt.length < 50) {
      errors.push("Story excerpt is required (minimum 50 characters)");
    }

    if (!story.content || story.content.length < 100) {
      errors.push("Story content is required (minimum 100 characters)");
    }

    if (story.StoryImage.length === 0) {
      errors.push("At least one hero image is required");
    }

    if (story.StoryTag.length === 0) {
      warnings.push("No tags assigned - story may be harder to discover");
    }

    if (!story.seoTitle || story.seoTitle.length < 10) {
      warnings.push("SEO title is missing or too short");
    }

    if (!story.seoDescription || story.seoDescription.length < 50) {
      warnings.push("SEO description is missing or too short");
    }

    return {
      valid: errors.length === 0,
      errors,
      warnings,
      canPublish: errors.length === 0,
    };
  },

  async publishStory(storyId: string, userId: string, scheduledAt?: string) {
    const story = await prisma.story.findFirst({
      where: { id: storyId, deleted: false },
    });

    if (!story) return null;

    const validation = await this.validateForPublish(storyId, userId);
    if (!validation.valid) {
      return { success: false, errors: validation.errors };
    }

    const updated = await prisma.story.update({
      where: { id: storyId },
      data: {
        status: "Published" as any,
        publishedAt: scheduledAt ? new Date(scheduledAt) : new Date(),
        scheduledAt: scheduledAt ? new Date(scheduledAt) : null,
        version: { increment: 1 },
      },
      select: {
        id: true,
        slug: true,
        title: true,
        status: true,
        publishedAt: true,
        scheduledAt: true,
      },
    });

    // Generate a UUID for the revision record
    const { v4: uuidv4 } = await import("uuid");

    // Create a revision record for the publish
    await prisma.storyRevision.create({
      data: {
        id: uuidv4(),
        storyId: story.id,
        title: story.title,
        excerpt: story.excerpt ?? "",
        content: story.content ?? "",
        changedBy: userId,
        version: story.version + 1,
      },
    });

    return {
      success: true,
      story: updated,
      message: scheduledAt
        ? "Story scheduled for publication"
        : "Story published successfully",
    };
  },
};
