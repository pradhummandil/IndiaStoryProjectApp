import { publishRepository } from "../../repositories/publishRepository";
import {
  UnauthorizedError,
  BadRequestError,
  NotFoundError,
} from "../../core/errors/apiErrors";

export const publishController = {
  async getPublishReview(req: any) {
    const userId = req.user?.id;
    if (!userId) {
      throw new UnauthorizedError("Authentication required");
    }

    const storyId = req.params.storyId as string;
    if (!storyId) {
      throw new BadRequestError("storyId parameter is required");
    }

    const data = await publishRepository.getPublishReview(storyId, userId);
    if (!data) {
      throw new NotFoundError("Story not found");
    }

    return data;
  },

  async validate(req: any) {
    const userId = req.user?.id;
    if (!userId) {
      throw new UnauthorizedError("Authentication required");
    }

    const { storyId } = req.body ?? {};
    if (!storyId) {
      throw new BadRequestError("storyId is required");
    }

    return publishRepository.validateForPublish(storyId, userId);
  },

  async publish(req: any) {
    const userId = req.user?.id;
    if (!userId) {
      throw new UnauthorizedError("Authentication required");
    }

    const storyId = req.params.storyId as string;
    if (!storyId) {
      throw new BadRequestError("storyId parameter is required");
    }

    const { scheduledAt } = req.body ?? {};

    const result = await publishRepository.publishStory(
      storyId,
      userId,
      scheduledAt,
    );

    if (!result) {
      throw new NotFoundError("Story not found");
    }

    if (!result.success) {
      return {
        success: false,
        errors: result.errors,
        message: "Validation failed. Please fix the errors and try again.",
      };
    }

    return result;
  },
};
