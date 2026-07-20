// -- AI Assistant Chat Models --------------------------------------------

class AiChatMessage {
  final String role;
  final String content;
  final DateTime timestamp;

  const AiChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  factory AiChatMessage.text({required String role, required String content}) =>
      AiChatMessage(role: role, content: content, timestamp: DateTime.now());

  Map<String, dynamic> toJson() => {'role': role, 'content': content};

  factory AiChatMessage.fromJson(Map<String, dynamic> json) => AiChatMessage(
    role: json['role'] as String? ?? 'user',
    content: json['content'] as String? ?? '',
    timestamp: json['timestamp'] != null
        ? DateTime.parse(json['timestamp'] as String)
        : DateTime.now(),
  );
}

class AiChatResponse {
  final String reply;
  final Map<String, dynamic>? storyContext;

  const AiChatResponse({required this.reply, this.storyContext});

  factory AiChatResponse.fromJson(Map<String, dynamic> json) => AiChatResponse(
    reply: json['reply'] as String? ?? '',
    storyContext: json['storyContext'] as Map<String, dynamic>?,
  );
}

// -- AI Assistant Context Models -----------------------------------------

class AiAssistantUser {
  final String name;
  final String? bio;
  final String? favoriteState;
  final String? favoriteTheme;

  const AiAssistantUser({
    required this.name,
    this.bio,
    this.favoriteState,
    this.favoriteTheme,
  });

  factory AiAssistantUser.fromJson(Map<String, dynamic> json) =>
      AiAssistantUser(
        name: json['name'] as String? ?? 'Writer',
        bio: json['bio'] as String?,
        favoriteState: json['favoriteState'] as String?,
        favoriteTheme: json['favoriteTheme'] as String?,
      );
}

class AiAssistantTag {
  final String id;
  final String name;
  final String slug;

  const AiAssistantTag({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory AiAssistantTag.fromJson(Map<String, dynamic> json) => AiAssistantTag(
    id: json['id'] as String,
    name: json['name'] as String,
    slug: json['slug'] as String,
  );
}

class AiAssistantTheme {
  final String id;
  final String name;
  final String slug;

  const AiAssistantTheme({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory AiAssistantTheme.fromJson(Map<String, dynamic> json) =>
      AiAssistantTheme(
        id: json['id'] as String,
        name: json['name'] as String,
        slug: json['slug'] as String,
      );
}

class AiAssistantState {
  final String id;
  final String name;
  final String slug;

  const AiAssistantState({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory AiAssistantState.fromJson(Map<String, dynamic> json) =>
      AiAssistantState(
        id: json['id'] as String,
        name: json['name'] as String,
        slug: json['slug'] as String,
      );
}

class StoryContext {
  final String id;
  final String title;
  final String? excerpt;
  final int contentLength;
  final String status;
  final String slug;
  final List<AiAssistantTag> tags;
  final List<AiAssistantTheme> themes;

  const StoryContext({
    required this.id,
    required this.title,
    this.excerpt,
    this.contentLength = 0,
    this.status = 'Draft',
    required this.slug,
    this.tags = const [],
    this.themes = const [],
  });

  factory StoryContext.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tags'] as List<dynamic>?;
    final rawThemes = json['themes'] as List<dynamic>?;

    return StoryContext(
      id: json['id'] as String,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String?,
      contentLength: (json['contentLength'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'Draft',
      slug: json['slug'] as String,
      tags:
          rawTags
              ?.map((e) => AiAssistantTag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      themes:
          rawThemes
              ?.map((e) => AiAssistantTheme.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class AiAssistantContext {
  final AiAssistantUser user;
  final StoryContext? currentStory;
  final List<AiAssistantTag> availableTags;
  final List<AiAssistantTheme> availableThemes;
  final List<AiAssistantState> availableStates;

  const AiAssistantContext({
    required this.user,
    this.currentStory,
    this.availableTags = const [],
    this.availableThemes = const [],
    this.availableStates = const [],
  });

  factory AiAssistantContext.fromJson(Map<String, dynamic> json) {
    final rawTags = json['availableTags'] as List<dynamic>?;
    final rawThemes = json['availableThemes'] as List<dynamic>?;
    final rawStates = json['availableStates'] as List<dynamic>?;

    return AiAssistantContext(
      user: AiAssistantUser.fromJson(json['user'] as Map<String, dynamic>),
      currentStory: json['currentStory'] != null
          ? StoryContext.fromJson(json['currentStory'] as Map<String, dynamic>)
          : null,
      availableTags:
          rawTags
              ?.map((e) => AiAssistantTag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      availableThemes:
          rawThemes
              ?.map((e) => AiAssistantTheme.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      availableStates:
          rawStates
              ?.map((e) => AiAssistantState.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// -- SEO Suggestion Models -----------------------------------------------

class SeoSuggestionResponse {
  final int score;
  final List<String> suggestions;
  final List<String> keywords;
  final String? currentSeoTitle;
  final String? currentSeoDescription;

  const SeoSuggestionResponse({
    this.score = 0,
    this.suggestions = const [],
    this.keywords = const [],
    this.currentSeoTitle,
    this.currentSeoDescription,
  });

  factory SeoSuggestionResponse.fromJson(Map<String, dynamic> json) {
    final rawSuggestions = json['suggestions'] as List<dynamic>?;
    final rawKeywords = json['keywords'] as List<dynamic>?;

    return SeoSuggestionResponse(
      score: (json['score'] as num?)?.toInt() ?? 0,
      suggestions: rawSuggestions?.map((e) => e as String).toList() ?? [],
      keywords: rawKeywords?.map((e) => e as String).toList() ?? [],
      currentSeoTitle: json['currentSeoTitle'] as String?,
      currentSeoDescription: json['currentSeoDescription'] as String?,
    );
  }
}

// -- Title Suggestion Models ---------------------------------------------

class TitleSuggestionResponse {
  final List<String> titles;
  final String? currentTitle;

  const TitleSuggestionResponse({this.titles = const [], this.currentTitle});

  factory TitleSuggestionResponse.fromJson(Map<String, dynamic> json) {
    final rawTitles = json['titles'] as List<dynamic>?;

    return TitleSuggestionResponse(
      titles: rawTitles?.map((e) => e as String).toList() ?? [],
      currentTitle: json['currentTitle'] as String?,
    );
  }
}

// -- Outline Models ------------------------------------------------------

class OutlineItem {
  final String heading;
  final String description;

  const OutlineItem({required this.heading, required this.description});

  factory OutlineItem.fromJson(Map<String, dynamic> json) => OutlineItem(
    heading: json['heading'] as String,
    description: json['description'] as String? ?? '',
  );
}

class OutlineResponse {
  final List<OutlineItem> outline;

  const OutlineResponse({this.outline = const []});

  factory OutlineResponse.fromJson(Map<String, dynamic> json) {
    final rawOutline = json['outline'] as List<dynamic>?;

    return OutlineResponse(
      outline:
          rawOutline
              ?.map((e) => OutlineItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// -- Rewrite Response ----------------------------------------------------

class RewriteResponse {
  final String original;
  final String rewritten;
  final String tone;
  final List<String> changes;

  const RewriteResponse({
    required this.original,
    required this.rewritten,
    required this.tone,
    this.changes = const [],
  });

  factory RewriteResponse.fromJson(Map<String, dynamic> json) {
    final rawChanges = json['changes'] as List<dynamic>?;

    return RewriteResponse(
      original: json['original'] as String? ?? '',
      rewritten: json['rewritten'] as String? ?? '',
      tone: json['tone'] as String? ?? 'editorial',
      changes: rawChanges?.map((e) => e as String).toList() ?? [],
    );
  }
}

// -- Summary Response ----------------------------------------------------

class SummaryResponse {
  final String summary;
  final String length;

  const SummaryResponse({required this.summary, this.length = 'medium'});

  factory SummaryResponse.fromJson(Map<String, dynamic> json) =>
      SummaryResponse(
        summary: json['summary'] as String? ?? '',
        length: json['length'] as String? ?? 'medium',
      );
}
