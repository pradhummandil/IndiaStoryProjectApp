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

interface AiProvider {
  invoke(prompt: string, context: Record<string, unknown>): Promise<string>;
}

/** Placeholder AI provider - replace with real LLM integration */
const defaultProvider: AiProvider = {
  async invoke(prompt: string, _context: Record<string, unknown>) {
    // Production: Replace this with actual LLM API call.
    // The prompt plus context contain all the data needed.
    // Return structured JSON string that the controller parses.
    return JSON.stringify({
      message: `[AI Provider]: ${prompt.substring(0, 100)}...`,
    });
  },
};

let provider: AiProvider = defaultProvider;

/** Allow swapping the AI provider at startup (e.g., from env config) */
export function setAiProvider(p: AiProvider) {
  provider = p;
}

export async function invokeAiWithContext(
  prompt: string,
  context: Record<string, unknown>,
): Promise<string> {
  return provider.invoke(prompt, context);
}
