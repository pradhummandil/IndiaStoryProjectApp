import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/story.dart';
import '../providers/story_providers.dart';
import '../widgets/story_hero_image.dart';
import '../widgets/story_header_info.dart';
import '../widgets/story_audio_bar.dart';
import '../widgets/story_content_renderer.dart';
import '../widgets/story_fact_card.dart';
import '../widgets/story_bottom_action_bar.dart';
import '../widgets/story_reading_progress_bar.dart';

/// Story Detail / Reading Experience screen.
///
/// Matches `design/story_reading_experience_production_v2/code.html` exactly.
class StoryDetailScreen extends ConsumerWidget {
  const StoryDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsync = ref.watch(storyDetailProvider(slug));

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F3),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(child: _buildContent(context, ref, storyAsync)),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: StoryBottomActionBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<StoryDetailResponse> storyAsync,
  ) {
    return storyAsync.when(
      data: (data) => _StoryDetailBody(data: data),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _StoryErrorRetry(
        message: error.toString(),
        onRetry: () => ref.invalidate(storyDetailProvider(slug)),
      ),
    );
  }
}

class _StoryErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _StoryErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 48, color: colors.error),
            const SizedBox(height: 16),
            Text(
              'Could not load story',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryDetailBody extends StatelessWidget {
  final StoryDetailResponse data;

  const _StoryDetailBody({required this.data});

  @override
  Widget build(BuildContext context) {
    final story = data.story;
    final author = data.author;
    final category = data.category;
    final stats = data.readingStatistics;
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Column(
      children: [
        _StoryTopNavBar(),
        const StoryReadingProgressBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 72),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StoryHeroImage(
                  imageUrl: story.images.isNotEmpty
                      ? story.images.first.imageUrl
                      : null,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 64 : 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StoryHeaderInfo(
                        story: story,
                        author: author,
                        category: category,
                      ),
                      StoryAudioBar(authorName: author.name),
                      const SizedBox(height: 24),
                      StoryContentRenderer(content: story.excerpt ?? ''),
                      if (stats.viewCount > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: StoryFactCard(
                            icon: Icons.visibility_outlined,
                            title: 'Reading Statistics',
                            description:
                                '${stats.viewCount} views \u00b7 ${stats.likesCount} likes \u00b7 ${stats.bookmarkCount} bookmarks',
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Fixed top navigation — matches HTML: arrow_back + HERITAGE + search
class _StoryTopNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: colors.onSurface,
          ),
          const Spacer(),
          Text(
            'HERITAGE',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
            color: colors.onSurface,
          ),
        ],
      ),
    );
  }
}
