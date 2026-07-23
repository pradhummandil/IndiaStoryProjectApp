"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.aiAssistantRepository = void 0;
const prismaClient_1 = require("../prisma/prismaClient");
exports.aiAssistantRepository = {
    async getStoryContext(userId, storyId) {
        // Fetch the user's profile for context
        const userProfile = await prismaClient_1.prisma.userProfile.findUnique({
            where: { id: userId },
            select: {
                name: true,
                bio: true,
                favoriteState: true,
                favoriteTheme: true,
            },
        });
        // If a storyId is provided, fetch that story's context
        let storyContext = null;
        if (storyId && userProfile?.name) {
            const author = await prismaClient_1.prisma.author.findFirst({
                where: { name: userProfile.name },
                select: { id: true },
            });
            if (author) {
                const story = await prismaClient_1.prisma.story.findFirst({
                    where: { id: storyId, authorId: author.id, deleted: false },
                    select: {
                        id: true,
                        title: true,
                        excerpt: true,
                        content: true,
                        status: true,
                        slug: true,
                        stateId: true,
                        cityId: true,
                        StoryTag: {
                            take: 10,
                            select: { Tag: { select: { id: true, name: true, slug: true } } },
                        },
                        StoryTheme: {
                            take: 10,
                            select: {
                                Theme: { select: { id: true, name: true, slug: true } },
                            },
                        },
                    },
                });
                if (story) {
                    storyContext = {
                        id: story.id,
                        title: story.title,
                        excerpt: story.excerpt,
                        contentLength: story.content?.length ?? 0,
                        status: story.status,
                        slug: story.slug,
                        tags: story.StoryTag.map((st) => st.Tag),
                        themes: story.StoryTheme.map((st) => st.Theme),
                    };
                }
            }
        }
        // Fetch available tags and themes for suggestions
        const tags = await prismaClient_1.prisma.tag.findMany({
            take: 50,
            orderBy: { name: "asc" },
            select: { id: true, name: true, slug: true },
        });
        const themes = await prismaClient_1.prisma.theme.findMany({
            take: 50,
            orderBy: { name: "asc" },
            select: { id: true, name: true, slug: true },
        });
        const states = await prismaClient_1.prisma.state.findMany({
            take: 50,
            orderBy: { name: "asc" },
            select: { id: true, name: true, slug: true },
        });
        return {
            user: {
                name: userProfile?.name ?? "Writer",
                bio: userProfile?.bio,
                favoriteState: userProfile?.favoriteState,
                favoriteTheme: userProfile?.favoriteTheme,
            },
            currentStory: storyContext,
            availableTags: tags,
            availableThemes: themes,
            availableStates: states,
        };
    },
    async getSuggestions(userId, storyId, contentType) {
        const userProfile = await prismaClient_1.prisma.userProfile.findUnique({
            where: { id: userId },
            select: { name: true },
        });
        if (!userProfile?.name)
            return { suggestions: [] };
        const author = await prismaClient_1.prisma.author.findFirst({
            where: { name: userProfile.name },
            select: { id: true },
        });
        if (!author)
            return { suggestions: [] };
        const story = await prismaClient_1.prisma.story.findFirst({
            where: { id: storyId, authorId: author.id, deleted: false },
            select: { title: true, excerpt: true, content: true },
        });
        if (!story)
            return { suggestions: [] };
        // Return context for the AI to use on the frontend
        return {
            suggestions: [
                {
                    type: contentType,
                    original: story.excerpt?.substring(0, 200) ?? "",
                    prompt: `Improve the following ${contentType} text while preserving its heritage/cultural storytelling tone`,
                },
            ],
            storyContext: {
                title: story.title,
                excerptLength: story.excerpt?.length ?? 0,
                contentLength: story.content?.length ?? 0,
            },
        };
    },
    async getSeoSuggestions(userId, storyId) {
        const userProfile = await prismaClient_1.prisma.userProfile.findUnique({
            where: { id: userId },
            select: { name: true },
        });
        if (!userProfile?.name) {
            return {
                score: 0,
                suggestions: [],
                keywords: [],
            };
        }
        const author = await prismaClient_1.prisma.author.findFirst({
            where: { name: userProfile.name },
            select: { id: true },
        });
        if (!author) {
            return {
                score: 0,
                suggestions: [],
                keywords: [],
            };
        }
        const story = await prismaClient_1.prisma.story.findFirst({
            where: { id: storyId, authorId: author.id, deleted: false },
            select: {
                title: true,
                excerpt: true,
                seoTitle: true,
                seoDescription: true,
                seoKeywords: true,
                slug: true,
                StoryTag: { take: 10, select: { Tag: { select: { name: true } } } },
            },
        });
        if (!story) {
            return { score: 0, suggestions: [], keywords: [] };
        }
        const existingKeywords = story.seoKeywords
            ?.split(",")
            .map((k) => k.trim())
            .filter(Boolean) ?? [];
        const tagNames = story.StoryTag.map((st) => st.Tag.name);
        // Compute a basic SEO score
        let score = 0;
        const suggestions = [];
        if (story.seoTitle && story.seoTitle.length > 10)
            score += 25;
        else
            suggestions.push("Add a descriptive SEO title (minimum 10 characters)");
        if (story.seoDescription && story.seoDescription.length > 50)
            score += 25;
        else
            suggestions.push("Write an SEO meta description (50-160 characters recommended)");
        if (story.excerpt && story.excerpt.length > 80)
            score += 20;
        else
            suggestions.push("Add a compelling story excerpt for better search visibility");
        if (existingKeywords.length >= 3)
            score += 15;
        else
            suggestions.push("Add at least 3 SEO keywords");
        if (tagNames.length >= 2)
            score += 15;
        else
            suggestions.push("Add more tags to improve content categorization");
        return {
            score,
            suggestions,
            keywords: [...new Set([...existingKeywords, ...tagNames])],
            currentSeoTitle: story.seoTitle,
            currentSeoDescription: story.seoDescription,
        };
    },
    async generateTitleSuggestions(userId, storyId) {
        const userProfile = await prismaClient_1.prisma.userProfile.findUnique({
            where: { id: userId },
            select: { name: true },
        });
        if (!userProfile?.name)
            return { titles: [] };
        const author = await prismaClient_1.prisma.author.findFirst({
            where: { name: userProfile.name },
            select: { id: true },
        });
        if (!author)
            return { titles: [] };
        const story = await prismaClient_1.prisma.story.findFirst({
            where: { id: storyId, authorId: author.id, deleted: false },
            select: { title: true, excerpt: true, content: true },
        });
        if (!story)
            return { titles: [] };
        // Return titles based on content analysis
        const titles = [];
        if (story.title) {
            titles.push(story.title);
        }
        if (story.excerpt) {
            const words = story.excerpt.split(" ").slice(0, 8);
            titles.push(words.join(" "));
        }
        return {
            titles: [
                ...titles,
                `The Untold Story of ${story.title}`,
                `Discovering ${story.title}: A Journey Through Time`,
                `${story.title}: Heritage and Legacy`,
            ].slice(0, 5),
            currentTitle: story.title,
        };
    },
    async generateOutline(userId, storyId) {
        const userProfile = await prismaClient_1.prisma.userProfile.findUnique({
            where: { id: userId },
            select: { name: true },
        });
        if (!userProfile?.name)
            return { outline: [] };
        const author = await prismaClient_1.prisma.author.findFirst({
            where: { name: userProfile.name },
            select: { id: true },
        });
        if (!author)
            return { outline: [] };
        const story = await prismaClient_1.prisma.story.findFirst({
            where: { id: storyId, authorId: author.id, deleted: false },
            select: { title: true, excerpt: true },
        });
        if (!story)
            return { outline: [] };
        return {
            outline: [
                {
                    heading: "Introduction",
                    description: `Set the scene for ${story.title}`,
                },
                {
                    heading: "Historical Context",
                    description: "Explore the historical background and significance",
                },
                {
                    heading: "Cultural Significance",
                    description: "Delve into the cultural impact and traditions",
                },
                {
                    heading: "Personal Narratives",
                    description: "Include voices and stories from local communities",
                },
                {
                    heading: "Modern Relevance",
                    description: "Connect the past to contemporary relevance",
                },
                {
                    heading: "Conclusion",
                    description: "Reflect on the enduring legacy and future preservation",
                },
            ],
            currentTitle: story.title,
        };
    },
};
