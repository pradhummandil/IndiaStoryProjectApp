import { profileRepository } from "../../repositories/profileRepository";
import { UnauthorizedError, NotFoundError } from "../../core/errors/apiErrors";

export const profileController = {
  async getProfile(req: any) {
    // Non-breaking: accept user id from header if auth middleware already sets it.
    // Common pattern in existing codebases: req.user?.id
    const userId: string | undefined =
      req.user?.id ?? req.headers["x-user-id"] ?? undefined;

    const profile = await profileRepository.getProfile(userId ?? null);
    if (!userId) throw new UnauthorizedError("Unauthorized");
    if (!profile) throw new NotFoundError("Profile not found");
    return profile;
  },
};
