import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/providers.dart';
import '../../domain/models/ai_assistant_models.dart';

/// Provider for AI assistant context (user profile, story context, metadata).
final aiAssistantContextProvider =
    FutureProvider.family<AiAssistantContext, String?>((ref, storyId) async {
      final repo = ref.watch(aiAssistantRepositoryProvider);
      return repo.getContext(storyId: storyId);
    });

/// Provider for sending a chat message to the AI assistant.
final aiChatProvider =
    FutureProvider.family<AiChatResponse, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final repo = ref.watch(aiAssistantRepositoryProvider);
      return repo.chat(
        storyId: params['storyId'] as String,
        message: params['message'] as String,
        history:
            (params['history'] as List<dynamic>?)
                ?.cast<Map<String, dynamic>>() ??
            [],
      );
    });

/// Provider for SEO suggestions.
final aiSeoProvider = FutureProvider.family<SeoSuggestionResponse, String>((
  ref,
  storyId,
) async {
  final repo = ref.watch(aiAssistantRepositoryProvider);
  return repo.getSeoSuggestions(storyId: storyId);
});

/// Provider for title suggestions.
final aiTitleProvider = FutureProvider.family<TitleSuggestionResponse, String>((
  ref,
  storyId,
) async {
  final repo = ref.watch(aiAssistantRepositoryProvider);
  return repo.getTitleSuggestions(storyId: storyId);
});

/// Provider for outline generation.
final aiOutlineProvider = FutureProvider.family<OutlineResponse, String>((
  ref,
  storyId,
) async {
  final repo = ref.watch(aiAssistantRepositoryProvider);
  return repo.getOutline(storyId: storyId);
});

/// Provider for content rewrite.
final aiRewriteProvider =
    FutureProvider.family<RewriteResponse, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final repo = ref.watch(aiAssistantRepositoryProvider);
      return repo.rewrite(
        storyId: params['storyId'] as String,
        content: params['content'] as String,
        tone: params['tone'] as String? ?? 'editorial',
      );
    });

/// Provider for summary generation.
final aiSummaryProvider =
    FutureProvider.family<SummaryResponse, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final repo = ref.watch(aiAssistantRepositoryProvider);
      return repo.getSummary(
        storyId: params['storyId'] as String,
        content: params['content'] as String,
        length: params['length'] as String? ?? 'medium',
      );
    });
