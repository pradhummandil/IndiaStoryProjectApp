// -- Publish Review Models -----------------------------------------------

class PublishReviewStory {
  final String id;
  final String slug;
  final String title;
  final String? excerpt;
  final String? content;
  final int? readingTime;
  final String status;
  final DateTime? publishedAt;
  final String? seoTitle;
  final String? seoDescription;
  final String? seoKeywords;
  final int viewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PublishReviewStory({
    required this.id,
    required this.slug,
    required this.title,
    this.excerpt,
    this.content,
    this.readingTime,
    this.status = 'Draft',
    this.publishedAt,
    this.seoTitle,
    this.seoDescription,
    this.seoKeywords,
    this.viewCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PublishReviewStory.fromJson(Map<String, dynamic> json) =>
      PublishReviewStory(
        id: json['id'] as String,
        slug: json['slug'] as String,
        title: json['title'] as String,
        excerpt: json['excerpt'] as String?,
        content: json['content'] as String?,
        readingTime: (json['readingTime'] as num?)?.toInt(),
        status: json['status'] as String? ?? 'Draft',
        publishedAt: json['publishedAt'] != null
            ? DateTime.parse(json['publishedAt'] as String)
            : null,
        seoTitle: json['seoTitle'] as String?,
        seoDescription: json['seoDescription'] as String?,
        seoKeywords: json['seoKeywords'] as String?,
        viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

class PublishReviewAuthor {
  final String id;
  final String name;
  final String? avatar;
  final String? bio;

  const PublishReviewAuthor({
    required this.id,
    required this.name,
    this.avatar,
    this.bio,
  });

  factory PublishReviewAuthor.fromJson(Map<String, dynamic> json) =>
      PublishReviewAuthor(
        id: json['id'] as String,
        name: json['name'] as String,
        avatar: json['avatar'] as String?,
        bio: json['bio'] as String?,
      );
}

class PublishReviewCategory {
  final dynamic state;
  final dynamic city;

  const PublishReviewCategory({this.state, this.city});

  factory PublishReviewCategory.fromJson(Map<String, dynamic> json) =>
      PublishReviewCategory(state: json['state'], city: json['city']);
}

class PublishReviewImage {
  final String imageUrl;
  final int sortOrder;
  final String? caption;
  final bool heroImage;

  const PublishReviewImage({
    required this.imageUrl,
    this.sortOrder = 0,
    this.caption,
    this.heroImage = false,
  });

  factory PublishReviewImage.fromJson(Map<String, dynamic> json) =>
      PublishReviewImage(
        imageUrl: json['imageUrl'] as String,
        sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
        caption: json['caption'] as String?,
        heroImage: json['heroImage'] as bool? ?? false,
      );
}

class PublishReviewTag {
  final String id;
  final String name;
  final String slug;

  const PublishReviewTag({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory PublishReviewTag.fromJson(Map<String, dynamic> json) =>
      PublishReviewTag(
        id: json['id'] as String,
        name: json['name'] as String,
        slug: json['slug'] as String,
      );
}

class SeoCheck {
  final String label;
  final bool passed;
  final String message;

  const SeoCheck({
    required this.label,
    required this.passed,
    required this.message,
  });

  factory SeoCheck.fromJson(Map<String, dynamic> json) => SeoCheck(
    label: json['label'] as String,
    passed: json['passed'] as bool? ?? false,
    message: json['message'] as String? ?? '',
  );
}

class SeoData {
  final int score;
  final List<SeoCheck> checks;
  final int passedCount;
  final int totalCount;

  const SeoData({
    this.score = 0,
    this.checks = const [],
    this.passedCount = 0,
    this.totalCount = 0,
  });

  factory SeoData.fromJson(Map<String, dynamic> json) {
    final rawChecks = json['checks'] as List<dynamic>?;

    return SeoData(
      score: (json['score'] as num?)?.toInt() ?? 0,
      checks:
          rawChecks
              ?.map((e) => SeoCheck.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      passedCount: (json['passedCount'] as num?)?.toInt() ?? 0,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class VersionHistoryItem {
  final String id;
  final String title;
  final int version;
  final DateTime createdAt;
  final String changedBy;

  const VersionHistoryItem({
    required this.id,
    required this.title,
    required this.version,
    required this.createdAt,
    required this.changedBy,
  });

  factory VersionHistoryItem.fromJson(Map<String, dynamic> json) =>
      VersionHistoryItem(
        id: json['id'] as String,
        title: json['title'] as String,
        version: (json['version'] as num?)?.toInt() ?? 1,
        createdAt: DateTime.parse(json['createdAt'] as String),
        changedBy: json['changedBy'] as String? ?? '',
      );
}

class RelatedStoryItem {
  final String id;
  final String slug;
  final String title;
  final String? excerpt;
  final int? readingTime;
  final dynamic author;

  const RelatedStoryItem({
    required this.id,
    required this.slug,
    required this.title,
    this.excerpt,
    this.readingTime,
    this.author,
  });

  factory RelatedStoryItem.fromJson(Map<String, dynamic> json) =>
      RelatedStoryItem(
        id: json['id'] as String,
        slug: json['slug'] as String,
        title: json['title'] as String,
        excerpt: json['excerpt'] as String?,
        readingTime: (json['readingTime'] as num?)?.toInt(),
        author: json['Author'],
      );
}

class PublishReviewResponse {
  final PublishReviewStory story;
  final PublishReviewAuthor author;
  final PublishReviewCategory category;
  final List<PublishReviewImage> images;
  final List<PublishReviewTag> tags;
  final List<PublishReviewTag> themes;
  final SeoData seo;
  final List<VersionHistoryItem> versionHistory;
  final List<RelatedStoryItem> relatedStories;

  const PublishReviewResponse({
    required this.story,
    required this.author,
    required this.category,
    this.images = const [],
    this.tags = const [],
    this.themes = const [],
    required this.seo,
    this.versionHistory = const [],
    this.relatedStories = const [],
  });

  factory PublishReviewResponse.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'] as List<dynamic>?;
    final rawTags = json['tags'] as List<dynamic>?;
    final rawThemes = json['themes'] as List<dynamic>?;
    final rawVersionHistory = json['versionHistory'] as List<dynamic>?;
    final rawRelatedStories = json['relatedStories'] as List<dynamic>?;

    return PublishReviewResponse(
      story: PublishReviewStory.fromJson(json['story'] as Map<String, dynamic>),
      author: PublishReviewAuthor.fromJson(
        json['author'] as Map<String, dynamic>,
      ),
      category: PublishReviewCategory.fromJson(
        json['category'] as Map<String, dynamic>,
      ),
      images:
          rawImages
              ?.map(
                (e) => PublishReviewImage.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      tags:
          rawTags
              ?.map((e) => PublishReviewTag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      themes:
          rawThemes
              ?.map((e) => PublishReviewTag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      seo: SeoData.fromJson(json['seo'] as Map<String, dynamic>),
      versionHistory:
          rawVersionHistory
              ?.map(
                (e) => VersionHistoryItem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      relatedStories:
          rawRelatedStories
              ?.map((e) => RelatedStoryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// -- Validation Models ----------------------------------------------------

class PublishValidation {
  final bool valid;
  final List<String> errors;
  final List<String> warnings;
  final bool canPublish;

  const PublishValidation({
    this.valid = false,
    this.errors = const [],
    this.warnings = const [],
    this.canPublish = false,
  });

  factory PublishValidation.fromJson(Map<String, dynamic> json) {
    final rawErrors = json['errors'] as List<dynamic>?;
    final rawWarnings = json['warnings'] as List<dynamic>?;

    return PublishValidation(
      valid: json['valid'] as bool? ?? false,
      errors: rawErrors?.map((e) => e as String).toList() ?? [],
      warnings: rawWarnings?.map((e) => e as String).toList() ?? [],
      canPublish: json['canPublish'] as bool? ?? false,
    );
  }
}

class PublishResult {
  final bool success;
  final dynamic story;
  final String? message;
  final List<String>? errors;

  const PublishResult({
    this.success = false,
    this.story,
    this.message,
    this.errors,
  });

  factory PublishResult.fromJson(Map<String, dynamic> json) {
    final rawErrors = json['errors'] as List<dynamic>?;

    return PublishResult(
      success: json['success'] as bool? ?? false,
      story: json['story'],
      message: json['message'] as String?,
      errors: rawErrors?.map((e) => e as String).toList(),
    );
  }
}
