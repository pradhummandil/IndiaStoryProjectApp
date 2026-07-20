import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../design_system/app_colors.dart';
import '../../../../design_system/app_shadows.dart';
import '../../domain/models/publish_models.dart';
import '../providers/publish_providers.dart';

/// Writer Studio Publish Review Screen.
///
/// Matches `design/writer_studio_publish_review/code.html` exactly.
class PublishReviewScreen extends ConsumerStatefulWidget {
  final String storyId;

  const PublishReviewScreen({super.key, required this.storyId});

  @override
  ConsumerState<PublishReviewScreen> createState() =>
      _PublishReviewScreenState();
}

class _PublishReviewScreenState extends ConsumerState<PublishReviewScreen> {
  bool _showSuccess = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final isTablet = MediaQuery.of(context).size.width >= 600 && !isDesktop;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                _TopAppBar(
                  colors: colors,
                  isDesktop: isDesktop,
                  onBack: () => context.pop(),
                ),
                Expanded(
                  child: ref
                      .watch(publishReviewProvider(widget.storyId))
                      .when(
                        data: (data) => _PublishBody(
                          data: data,
                          colors: colors,
                          isDesktop: isDesktop,
                          isTablet: isTablet,
                          storyId: widget.storyId,
                          onPublished: () =>
                              setState(() => _showSuccess = true),
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => _ErrorRetry(
                          message: error.toString(),
                          onRetry: () => ref.invalidate(
                            publishReviewProvider(widget.storyId),
                          ),
                        ),
                      ),
                ),
              ],
            ),
            // Success toast
            if (_showSuccess)
              _SuccessBanner(
                colors: colors,
                onDismiss: () => setState(() => _showSuccess = false),
              ),
            // Mobile bottom nav
            if (!isDesktop) _MobileBottomNav(colors: colors),
          ],
        ),
      ),
    );
  }
}

// -- Top App Bar ---------------------------------------------------------

class _TopAppBar extends StatelessWidget {
  final AppColors colors;
  final bool isDesktop;
  final VoidCallback onBack;

  const _TopAppBar({
    required this.colors,
    required this.isDesktop,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Icon(Icons.menu_rounded, color: colors.primary),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Text(
            'Writer Studio',
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: colors.primary,
              height: 40 / 32,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 64),
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Publish',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.05,
                  color: colors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -- Error Retry ---------------------------------------------------------

class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 48, color: colors.error),
            const SizedBox(height: 16),
            Text(
              'Could not load publish review',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colors.onBackground,
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

// -- Publish Body -------------------------------------------------------

class _PublishBody extends ConsumerWidget {
  final PublishReviewResponse data;
  final AppColors colors;
  final bool isDesktop;
  final bool isTablet;
  final String storyId;
  final VoidCallback onPublished;

  const _PublishBody({
    required this.data,
    required this.colors,
    required this.isDesktop,
    required this.isTablet,
    required this.storyId,
    required this.onPublished,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        isDesktop
            ? 64
            : isTablet
            ? 32
            : 20,
        isDesktop ? 64 : 32,
        isDesktop
            ? 64
            : isTablet
            ? 32
            : 20,
        isDesktop ? 32 : 120,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1152),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              _Breadcrumbs(colors: colors),
              const SizedBox(height: 16),
              // Title
              Text(
                'Publish & Review',
                style: TextStyle(
                  fontFamily: 'EB Garamond',
                  fontSize: isDesktop ? 64 : 40,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.02,
                  color: colors.onBackground,
                  height: isDesktop ? 72 / 64 : 48 / 40,
                ),
              ),
              const SizedBox(height: 32),
              // Grid: 2 columns on desktop
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 1024) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 7,
                          child: _LeftColumn(data: data, colors: colors),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 5,
                          child: _RightColumn(
                            data: data,
                            colors: colors,
                            storyId: storyId,
                            onPublished: onPublished,
                          ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _LeftColumn(data: data, colors: colors),
                      const SizedBox(height: 24),
                      _RightColumn(
                        data: data,
                        colors: colors,
                        storyId: storyId,
                        onPublished: onPublished,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -- Breadcrumbs ---------------------------------------------------------

class _Breadcrumbs extends StatelessWidget {
  final AppColors colors;

  const _Breadcrumbs({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Stories',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: colors.onSurfaceVariant,
            height: 16 / 12,
          ),
        ),
        Icon(Icons.chevron_right, size: 16, color: colors.onSurfaceVariant),
        Text(
          'Drafts',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: colors.onSurfaceVariant,
            height: 16 / 12,
          ),
        ),
        Icon(Icons.chevron_right, size: 16, color: colors.onSurfaceVariant),
        Text(
          'Publish & Review',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: colors.onBackground,
            height: 16 / 12,
          ),
        ),
      ],
    );
  }
}

// -- Left Column --------------------------------------------------------

class _LeftColumn extends StatelessWidget {
  final PublishReviewResponse data;
  final AppColors colors;

  const _LeftColumn({required this.data, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Pre-flight Checklist
        _PreflightChecklist(seo: data.seo, colors: colors),
        const SizedBox(height: 32),
        // Version History
        _VersionHistory(versions: data.versionHistory, colors: colors),
      ],
    );
  }
}

// -- Pre-flight Checklist -----------------------------------------------

class _PreflightChecklist extends StatelessWidget {
  final SeoData seo;
  final AppColors colors;

  const _PreflightChecklist({required this.seo, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A000000),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pre-flight Checklist',
                style: TextStyle(
                  fontFamily: 'EB Garamond',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: colors.onBackground,
                  height: 32 / 24,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2E8E8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${seo.passedCount} / ${seo.totalCount} Passed',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: colors.primary,
                    height: 16 / 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Checklist items
          ...seo.checks.map(
            (check) => Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: check != seo.checks.last
                  ? BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: colors.outlineVariant.withValues(alpha: 0.5),
                        ),
                      ),
                    )
                  : null,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    check.passed
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 20,
                    color: check.passed ? colors.primary : colors.outline,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          check.label,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.05,
                            color: colors.onBackground,
                            height: 20 / 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          check.message,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: colors.onSurfaceVariant,
                            height: 16 / 12,
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
      ),
    );
  }
}

// -- Version History ----------------------------------------------------

class _VersionHistory extends StatelessWidget {
  final List<VersionHistoryItem> versions;
  final AppColors colors;

  const _VersionHistory({required this.versions, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A000000),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Version History',
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colors.onBackground,
              height: 32 / 24,
            ),
          ),
          const SizedBox(height: 16),
          // Timeline
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              children: versions.asMap().entries.map((entry) {
                final index = entry.key;
                final version = entry.value;
                final isLast = index == versions.length - 1;
                final isFirst = index == 0;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeline dot + line
                      SizedBox(
                        width: 24,
                        child: Column(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: isFirst
                                    ? colors.primary
                                    : colors.outline,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colors.background,
                                  width: 3,
                                ),
                              ),
                            ),
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 1,
                                  color: colors.outlineVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Content
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                version.title,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.05,
                                  color: colors.onBackground,
                                  height: 20 / 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(version.createdAt),
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: colors.onSurfaceVariant,
                                  height: 16 / 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    final timeStr =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

    if (diff.inDays == 0) {
      return 'Today, $timeStr';
    } else if (diff.inDays == 1) {
      return 'Yesterday, $timeStr';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}, $timeStr';
    }
  }
}

// -- Right Column -------------------------------------------------------

class _RightColumn extends StatelessWidget {
  final PublishReviewResponse data;
  final AppColors colors;
  final String storyId;
  final VoidCallback onPublished;

  const _RightColumn({
    required this.data,
    required this.colors,
    required this.storyId,
    required this.onPublished,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Publishing Actions
        _PublishingActions(
          data: data,
          colors: colors,
          storyId: storyId,
          onPublished: onPublished,
        ),
        const SizedBox(height: 24),
        // Mobile Preview
        _MobilePreview(data: data, colors: colors),
      ],
    );
  }
}

// -- Publishing Actions -------------------------------------------------

class _PublishingActions extends ConsumerWidget {
  final PublishReviewResponse data;
  final AppColors colors;
  final String storyId;
  final VoidCallback onPublished;

  const _PublishingActions({
    required this.data,
    required this.colors,
    required this.storyId,
    required this.onPublished,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A000000),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.outlineVariant)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Publishing Options',
                  style: TextStyle(
                    fontFamily: 'EB Garamond',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: colors.onBackground,
                    height: 32 / 24,
                  ),
                ),
                // SEO score indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: data.seo.score >= 70
                        ? const Color(0xFFF2E8E8)
                        : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'SEO ${data.seo.score}%',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: data.seo.score >= 70
                          ? colors.primary
                          : const Color(0xFFE65100),
                      height: 16 / 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Publish Now button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                final result = await ref.read(
                  publishActionProvider({'storyId': storyId}).future,
                );
                if (result.success && context.mounted) {
                  onPublished();
                }
              },
              icon: const Icon(Icons.publish_rounded, size: 18),
              label: Text(
                'Publish Now',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.05,
                  color: colors.onPrimary,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF8B1E1E),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Schedule button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showSchedulePicker(context, ref);
              },
              icon: const Icon(Icons.schedule_rounded, size: 18),
              label: const Text('Schedule for Later'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF8B1E1E),
                side: const BorderSide(color: Color(0xFF8B1E1E)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.05,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSchedulePicker(BuildContext context, WidgetRef ref) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((date) {
      if (date != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(
            DateTime.now().add(const Duration(hours: 1)),
          ),
        ).then((time) {
          if (time != null) {
            final scheduledAt = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            ref
                .read(
                  publishActionProvider({
                    'storyId': storyId,
                    'scheduledAt': scheduledAt.toIso8601String(),
                  }).future,
                )
                .then((result) {
                  if (result.success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result.message ?? 'Story scheduled'),
                        backgroundColor: const Color(0xFF8B1E1E),
                      ),
                    );
                  }
                });
          }
        });
      }
    });
  }
}

// -- Mobile Preview -----------------------------------------------------

class _MobilePreview extends StatelessWidget {
  final PublishReviewResponse data;
  final AppColors colors;

  const _MobilePreview({required this.data, required this.colors});

  @override
  Widget build(BuildContext context) {
    final heroImage = data.images.isNotEmpty
        ? data.images.first.imageUrl
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mobile Preview',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.05,
                    color: colors.onSurfaceVariant,
                    height: 20 / 14,
                  ),
                ),
                Icon(
                  Icons.phone_android_rounded,
                  size: 18,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Device Frame
          Container(
            width: 320,
            height: 568,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: colors.surfaceContainerHighest,
                width: 8,
              ),
              boxShadow: [AppShadows().z1],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                // Camera notch
                Container(
                  width: 128,
                  height: 16,
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero image
                        if (heroImage != null)
                          Container(
                            height: 192,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(heroImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.all(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.surface.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Architecture',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: colors.onBackground,
                                    height: 16 / 12,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          Container(
                            height: 192,
                            color: colors.surfaceVariant,
                            child: Center(
                              child: Icon(
                                Icons.image_rounded,
                                size: 48,
                                color: colors.outline,
                              ),
                            ),
                          ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.story.title,
                                style: TextStyle(
                                  fontFamily: 'EB Garamond',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: colors.onBackground,
                                  height: 28 / 24,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'By ${data.author.name} \u2022 ${data.story.readingTime ?? 5} min read',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: colors.onSurfaceVariant,
                                  height: 16 / 12,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (data.story.excerpt != null)
                                Text(
                                  data.story.excerpt!,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: colors.onBackground,
                                    height: 20 / 14,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -- Success Banner -----------------------------------------------------

class _SuccessBanner extends StatelessWidget {
  final AppColors colors;
  final VoidCallback onDismiss;

  const _SuccessBanner({required this.colors, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 64,
      left: 0,
      right: 0,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x1A000000),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2E8E8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF6A020A),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Story Published Successfully',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.05,
                          color: colors.onBackground,
                          height: 20 / 14,
                        ),
                      ),
                      Text(
                        'Your narrative is now live.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: colors.onSurfaceVariant,
                          height: 16 / 12,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: onDismiss,
                  child: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: colors.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -- Mobile Bottom Nav --------------------------------------------------

class _MobileBottomNav extends StatelessWidget {
  final AppColors colors;

  const _MobileBottomNav({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(top: BorderSide(color: colors.outlineVariant)),
          boxShadow: [AppShadows().z1],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.edit_note_rounded,
                label: 'Drafts',
                active: true,
                colors: colors,
              ),
              _NavItem(
                icon: Icons.auto_stories_rounded,
                label: 'Published',
                active: false,
                colors: colors,
              ),
              _NavItem(
                icon: Icons.schedule_rounded,
                label: 'Scheduled',
                active: false,
                colors: colors,
              ),
              _NavItem(
                icon: Icons.analytics_rounded,
                label: 'SEO',
                active: false,
                colors: colors,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final AppColors colors;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: active ? colors.primary : colors.onSurfaceVariant,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              color: active ? colors.primary : colors.onSurfaceVariant,
              letterSpacing: 0.05,
            ),
          ),
        ],
      ),
    );
  }
}
