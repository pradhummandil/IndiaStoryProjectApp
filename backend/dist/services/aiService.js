"use strict";
/**
 * AI Service Layer
 *
 * Centralised AI integration point.
 * All AI calls are routed through this service.
 *
 * Currently uses Prisma-powered context plus structured prompts.
 * Replace aiProvider.invoke() with real LLM integration (OpenAI, Claude, etc.)
 * when available - no Flutter changes needed.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.setAiProvider = setAiProvider;
exports.invokeAiWithContext = invokeAiWithContext;
/** Placeholder AI provider - replace with real LLM integration */
const defaultProvider = {
    async invoke(prompt, _context) {
        // Production: Replace this with actual LLM API call.
        // The prompt plus context contain all the data needed.
        // Return structured JSON string that the controller parses.
        return JSON.stringify({
            message: `[AI Provider]: ${prompt.substring(0, 100)}...`,
        });
    },
};
let provider = defaultProvider;
/** Allow swapping the AI provider at startup (e.g., from env config) */
function setAiProvider(p) {
    provider = p;
}
async function invokeAiWithContext(prompt, context) {
    return provider.invoke(prompt, context);
}
