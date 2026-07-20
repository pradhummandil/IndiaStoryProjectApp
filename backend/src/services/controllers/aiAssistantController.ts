import { aiAssistantRepository } from "../../repositories/aiAssistantRepository";
import { invokeAiWithContext } from "../aiService";
import {
  UnauthorizedError,
  BadRequestError,
} from "../../core/errors/apiErrors";

export const aiAssistantController = {
  async getContext(req: any) {
    const userId = req.user?.id;
    if (!userId) {
      throw new UnauthorizedError("Authentication required");
    }

    const storyId: string | undefined = req.query.storyId as string | undefined;
    return aiAssistantRepository.getStoryContext(userId, storyId);
  },

  async chat(req: any) {
    const userId = req.user?.id;
    if (!userId) {
      throw new UnauthorizedError("Authentication required");
    }

    const { storyId, message, history } = req.body ?? {};
    if (!storyId || !message) {
      throw new BadRequestError("storyId and message are required");
    }

    // Fetch story context from Prisma
    const context = await aiAssistantRepository.getStoryContext(
      userId,
      storyId,
    );

    // Build prompt with context and conversation history
    const conversationHistory = (history ?? [])
      .map((h: any) => `${h.role}: ${h.content}`)
      .join("\n");

    const prompt = [
      `You are an AI writing assistant for India Story Project, a cultural heritage storytelling platform.`,
      `Writer: ${context.user.name}`,
      `Current story title: ${context.currentStory?.title ?? "Untitled"}`,
      `Story tags: ${context.currentStory?.tags?.map((t: any) => t.name).join(", ") ?? "None"}`,
      `Story themes: ${context.currentStory?.themes?.map((t: any) => t.name).join(", ") ?? "None"}`,
      ``,
      `Conversation history:`,
      conversationHistory || "No previous messages.",
      ``,
      `User message: ${message}`,
      ``,
      `Respond with helpful, editorial-quality writing advice for heritage storytelling.`,
    ].join("\n");

    const aiResponse = await invokeAiWithContext(prompt, {
      storyId,
      context: context as unknown as Record<string, unknown>,
    });

    return {
      reply: aiResponse,
      storyContext: {
        title: context.currentStory?.title,
        excerptLength: context.currentStory?.excerpt?.length ?? 0,
      },
    };
  },

  async rewrite(req: any) {
    const userId = req.user?.id;
    if (!userId) {
      throw new UnauthorizedError("Authentication required");
    }

    const { storyId, content, tone } = req.body ?? {};
    if (!storyId || !content) {
      throw new BadRequestError("storyId and content are required");
    }

    const context = await aiAssistantRepository.getStoryContext(
      userId,
      storyId,
    );

    const validTones = [
      "editorial",
      "academic",
      "conversational",
      "poetic",
      "journalistic",
      "simple",
    ];
    const selectedTone = validTones.includes(tone) ? tone : "editorial";

    const prompt = [
      `You are an editorial assistant for India Story Project.`,
      `Rewrite the following text in a "${selectedTone}" tone.`,
      `Preserve all factual information, cultural sensitivity, and heritage storytelling voice.`,
      ``,
      `Story title: ${context.currentStory?.title ?? "Untitled"}`,
      ``,
      `Text to rewrite:`,
      content,
      ``,
      `Return a JSON object with:`,
      `- "rewritten": the rewritten text`,
      `- "changes": an array of 3-5 brief descriptions of what was changed`,
      `- "tone": the tone used`,
    ].join("\n");

    const aiResponse = await invokeAiWithContext(prompt, {
      storyId,
      content,
      tone: selectedTone,
      context: context as unknown as Record<string, unknown>,
    });

    let parsed;
    try {
      parsed = JSON.parse(aiResponse);
    } catch {
      parsed = {
        rewritten: content,
        tone: selectedTone,
        changes: ["Text processed through AI service"],
      };
    }

    return {
      original: content,
      rewritten: parsed.rewritten ?? content,
      tone: parsed.tone ?? selectedTone,
      changes: parsed.changes ?? ["Text processed through AI service"],
    };
  },

  async seo(req: any) {
    const userId = req.user?.id;
    if (!userId) {
      throw new UnauthorizedError("Authentication required");
    }

    const storyId: string | undefined = req.body?.storyId as string | undefined;
    if (!storyId) {
      throw new BadRequestError("storyId is required");
    }

    return aiAssistantRepository.getSeoSuggestions(userId, storyId);
  },

  async title(req: any) {
    const userId = req.user?.id;
    if (!userId) {
      throw new UnauthorizedError("Authentication required");
    }

    const storyId: string | undefined = req.body?.storyId as string | undefined;
    if (!storyId) {
      throw new BadRequestError("storyId is required");
    }

    const context = await aiAssistantRepository.getStoryContext(
      userId,
      storyId,
    );

    const prompt = [
      `You are a title generation assistant for India Story Project.`,
      `Generate 5 compelling, SEO-friendly titles for a heritage/cultural story.`,
      `Each title should be evocative, include relevant keywords, and appeal to readers interested in Indian heritage.`,
      ``,
      `Story details:`,
      `Current title: ${context.currentStory?.title ?? "Untitled"}`,
      `Excerpt: ${context.currentStory?.excerpt?.substring(0, 200) ?? ""}`,
      `Tags: ${context.currentStory?.tags?.map((t: any) => t.name).join(", ") ?? ""}`,
      `Themes: ${context.currentStory?.themes?.map((t: any) => t.name).join(", ") ?? ""}`,
      ``,
      `Return a JSON object with:`,
      `- "titles": an array of 5 title strings`,
      `- "currentTitle": the original title`,
    ].join("\n");

    const aiResponse = await invokeAiWithContext(prompt, {
      storyId,
      context: context as unknown as Record<string, unknown>,
    });

    let parsed;
    try {
      parsed = JSON.parse(aiResponse);
    } catch {
      parsed = { titles: [], currentTitle: context.currentStory?.title };
    }

    return {
      titles: parsed.titles ?? [],
      currentTitle: context.currentStory?.title,
    };
  },

  async outline(req: any) {
    const userId = req.user?.id;
    if (!userId) {
      throw new UnauthorizedError("Authentication required");
    }

    const storyId: string | undefined = req.body?.storyId as string | undefined;
    if (!storyId) {
      throw new BadRequestError("storyId is required");
    }

    const context = await aiAssistantRepository.getStoryContext(
      userId,
      storyId,
    );

    const prompt = [
      `You are an outline generator for India Story Project.`,
      `Generate a structured 6-section outline for a heritage/cultural story.`,
      `Each section should have a heading and a brief description.`,
      ``,
      `Story details:`,
      `Title: ${context.currentStory?.title ?? "Untitled"}`,
      `Excerpt: ${context.currentStory?.excerpt?.substring(0, 200) ?? ""}`,
      `Tags: ${context.currentStory?.tags?.map((t: any) => t.name).join(", ") ?? ""}`,
      `Themes: ${context.currentStory?.themes?.map((t: any) => t.name).join(", ") ?? ""}`,
      ``,
      `Return a JSON object with:`,
      `- "outline": an array of objects, each with "heading" and "description"`,
      `- "currentTitle": the story title`,
    ].join("\n");

    const aiResponse = await invokeAiWithContext(prompt, {
      storyId,
      context: context as unknown as Record<string, unknown>,
    });

    let parsed;
    try {
      parsed = JSON.parse(aiResponse);
    } catch {
      parsed = { outline: [], currentTitle: context.currentStory?.title };
    }

    return {
      outline: parsed.outline ?? [],
      currentTitle: context.currentStory?.title,
    };
  },

  async summary(req: any) {
    const userId = req.user?.id;
    if (!userId) {
      throw new UnauthorizedError("Authentication required");
    }

    const { storyId, content, length } = req.body ?? {};
    if (!storyId || !content) {
      throw new BadRequestError("storyId and content are required");
    }

    const context = await aiAssistantRepository.getStoryContext(
      userId,
      storyId,
    );

    const targetLength = length === "short" ? "2-3 sentences" : "1 paragraph";

    const prompt = [
      `You are a summarization assistant for India Story Project.`,
      `Summarize the following story content in ${targetLength}.`,
      `Capture the essence of the heritage narrative while being concise.`,
      ``,
      `Story title: ${context.currentStory?.title ?? "Untitled"}`,
      ``,
      `Content to summarize:`,
      content.substring(0, 2000),
      ``,
      `Return a JSON object with:`,
      `- "summary": the generated summary text`,
      `- "length": "${length}"`,
    ].join("\n");

    const aiResponse = await invokeAiWithContext(prompt, {
      storyId,
      contentLength: content.length,
      context: context as unknown as Record<string, unknown>,
    });

    let parsed;
    try {
      parsed = JSON.parse(aiResponse);
    } catch {
      parsed = {
        summary: content.substring(0, 300),
        length: length ?? "medium",
      };
    }

    return {
      summary: parsed.summary ?? content.substring(0, 300),
      length: parsed.length ?? length ?? "medium",
    };
  },
};
