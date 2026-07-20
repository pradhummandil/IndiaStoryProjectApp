import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/app_colors.dart';
import '../../../../design_system/app_spacing.dart';
import '../../../../design_system/app_shadows.dart';
import '../../../../design_system/app_radius.dart';
import '../../domain/models/writer_dashboard_models.dart';
import '../providers/writer_providers.dart';

/// Writer Studio Dashboard Screen.
///
/// Matches `design/writer_studio_dashboard_audited/code.html` exactly.
class WriterStudioScreen extends ConsumerWidget {
  const WriterStudioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(writerDashboardProvider);
    final isDesktop = MediaQuery.of(context).size.width >= 768;
    final colors = AppColors();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Row(
              children: [
                // Desktop Navigation Drawer
                if (isDesktop) _DesktopSideNav(colors: colors),
                // Main Content
                Expanded(
                  child: Column(
                    children: [
                      _TopAppBar(colors: colors, isDesktop: isDesktop),
                      Expanded(
                        child: dashboardAsync.when(
                          data: (data) =>
                              _DashboardBody(data: data, colors: colors),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, stack) => _ErrorRetry(
                            message: error.toString(),
                            colors: colors,
                            onRetry: () =>
                                ref.invalidate(writerDashboardProvider),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Mobile Bottom Navigation
            if (!isDesktop) _MobileBottomNav(colors: colors),
          ],
        ),
      ),
    );
  }
}

// ── Error Retry Widget ───────────────────────────────────────────────

class _ErrorRetry extends StatelessWidget {
  final String message;
  final AppColors colors;
  final VoidCallback onRetry;

  const _ErrorRetry({
    required this.message,
    required this.colors,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 48, color: colors.error),
            const SizedBox(height: 16),
            Text(
              'Could not load dashboard',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colors.onBackground,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.textOnSurfaceVariant,
              ),
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

// ── Top App Bar ──────────────────────────────────────────────────────

class _TopAppBar extends StatelessWidget {
  final AppColors colors;
  final bool isDesktop;

  const _TopAppBar({required this.colors, required this.isDesktop});

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
          if (!isDesktop)
            IconButton(
              icon: Icon(Icons.menu_rounded, color: colors.primary),
              onPressed: () {},
            )
          else
            const SizedBox(width: 64),
          const Spacer(),
          Text(
            'Writer Studio',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: colors.primary,
              fontFamily: 'EB Garamond',
              fontWeight: FontWeight.w500,
              fontSize: 32,
              height: 40 / 32,
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(right: 64),
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF8B1E1E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
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
              child: const Text('Publish'),
            ),
          ),
          if (!isDesktop)
            const SizedBox(width: 16)
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}

// ── Desktop Side Nav ────────────────────────────────────────────────

class _DesktopSideNav extends StatelessWidget {
  final AppColors colors;

  const _DesktopSideNav({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(right: BorderSide(color: colors.outlineVariant)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Profile section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'EL',
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontFamily: 'EB Garamond',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Editorial Lead',
                      style: TextStyle(
                        fontFamily: 'EB Garamond',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: colors.primary,
                        height: 32 / 24,
                      ),
                    ),
                    Text(
                      'Cultural Storytelling',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: colors.textOnSurfaceVariant,
                        height: 16 / 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Navigation items
          _SideNavItem(
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
            isActive: true,
            colors: colors,
          ),
          _SideNavItem(
            icon: Icons.auto_stories_rounded,
            label: 'Stories',
            colors: colors,
          ),
          _SideNavItem(
            icon: Icons.analytics_rounded,
            label: 'Analytics',
            colors: colors,
          ),
          _SideNavItem(
            icon: Icons.auto_awesome_rounded,
            label: 'AI Assistant',
            colors: colors,
          ),
          const Spacer(),
          _SideNavItem(
            icon: Icons.settings_rounded,
            label: 'Settings',
            colors: colors,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SideNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final AppColors colors;

  const _SideNavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF2E8E8) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isActive
                      ? colors.primary
                      : colors.textOnSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.05,
                    color: isActive
                        ? colors.primary
                        : colors.textOnSurfaceVariant,
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

// ── Dashboard Body ──────────────────────────────────────────────────

class _DashboardBody extends StatelessWidget {
  final WriterDashboardResponse data;
  final AppColors colors;

  const _DashboardBody({required this.data, required this.colors});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 768;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            isDesktop ? 64 : 20,
            32,
            isDesktop ? 64 : 20,
            isDesktop ? 32 : 120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              _WelcomeHeader(colors: colors),
              const SizedBox(height: 32),
              // Bento Grid Overview
              _BentoGrid(data: data, colors: colors),
              const SizedBox(height: 120),
              // Active Projects Section
              _ActiveProjects(data: data, colors: colors),
            ],
          ),
        );
      },
    );
  }
}

// ── Welcome Header ──────────────────────────────────────────────────

class _WelcomeHeader extends StatelessWidget {
  final AppColors colors;

  const _WelcomeHeader({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning, Writer.',
          style: TextStyle(
            fontFamily: 'EB Garamond',
            fontSize: 40,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.01,
            color: colors.onBackground,
            height: 48 / 40,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Here is a summary of your stories documenting India's heritage.",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: colors.textOnSurfaceVariant,
            height: 28 / 18,
          ),
        ),
      ],
    );
  }
}

// ── Bento Grid ──────────────────────────────────────────────────────

class _BentoGrid extends StatelessWidget {
  final WriterDashboardResponse data;
  final AppColors colors;

  const _BentoGrid({required this.data, required this.colors});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 768;

        return Column(
          children: [
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _TotalReadsCard(stats: data.stats, colors: colors),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _AvgReadTimeCard(stats: data.stats, colors: colors),
                  ),
                  const SizedBox(width: 24),
                  Expanded(child: _QuickActionsCard(colors: colors)),
                ],
              )
            else
              Column(
                children: [
                  _TotalReadsCard(stats: data.stats, colors: colors),
                  const SizedBox(height: 24),
                  _AvgReadTimeCard(stats: data.stats, colors: colors),
                  const SizedBox(height: 24),
                  _QuickActionsCard(colors: colors),
                ],
              ),
          ],
        );
      },
    );
  }
}

// ── Total Reads Card ────────────────────────────────────────────────

class _TotalReadsCard extends StatelessWidget {
  final WriterDashboardStats stats;
  final AppColors colors;

  const _TotalReadsCard({required this.stats, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x05000000),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.visibility_rounded,
                size: 20,
                color: colors.textOnSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'TOTAL READS',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.05,
                  color: colors.textOnSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _formatNumber(stats.totalReads),
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: colors.onBackground,
              height: 40 / 32,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.trending_up, size: 16, color: colors.primary),
              const SizedBox(width: 4),
              Text(
                '+14% this month',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: colors.primary,
                  height: 16 / 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Avg Read Time Card ──────────────────────────────────────────────

class _AvgReadTimeCard extends StatelessWidget {
  final WriterDashboardStats stats;
  final AppColors colors;

  const _AvgReadTimeCard({required this.stats, required this.colors});

  @override
  Widget build(BuildContext context) {
    final minutes = stats.avgReadingTime ~/ 60;
    final seconds = stats.avgReadingTime % 60;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x05000000),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 20,
                color: colors.textOnSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'AVG. READ TIME',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.05,
                  color: colors.textOnSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${minutes}m ${seconds}s',
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: colors.onBackground,
              height: 40 / 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Solid engagement',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: colors.textOnSurfaceVariant,
              height: 16 / 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quick Actions Card ──────────────────────────────────────────────

class _QuickActionsCard extends StatelessWidget {
  final AppColors colors;

  const _QuickActionsCard({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF6E9),
        border: Border.all(color: colors.secondaryContainer),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x05000000),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colors.onBackground,
              height: 32 / 24,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_note_rounded),
              label: const Text('New Story'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF8B1E1E),
                foregroundColor: Colors.white,
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
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.auto_awesome_rounded),
              label: const Text('AI Brainstorm'),
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
}

// ── Active Projects Section ─────────────────────────────────────────

class _ActiveProjects extends ConsumerStatefulWidget {
  final WriterDashboardResponse data;
  final AppColors colors;

  const _ActiveProjects({required this.data, required this.colors});

  @override
  ConsumerState<_ActiveProjects> createState() => _ActiveProjectsState();
}

class _ActiveProjectsState extends ConsumerState<_ActiveProjects> {
  int _selectedTabIndex = 0;

  final List<String> _tabs = ['Drafts', 'Published', 'Scheduled'];

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    final stories = _getStoriesForTab();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Projects',
          style: TextStyle(
            fontFamily: 'EB Garamond',
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: colors.onBackground,
            height: 40 / 32,
          ),
        ),
        const SizedBox(height: 16),
        // Tab Headers
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colors.outlineVariant)),
          ),
          child: Row(
            children: List.generate(_tabs.length, (index) {
              final isActive = _selectedTabIndex == index;
              final count = _getTabCount(index);

              return GestureDetector(
                onTap: () => setState(() => _selectedTabIndex = index),
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 12,
                  ),
                  decoration: BoxDecoration(
                    border: isActive
                        ? Border(
                            bottom: BorderSide(
                              color: const Color(0xFF8B1E1E),
                              width: 2,
                            ),
                          )
                        : null,
                  ),
                  child: Text(
                    '${_tabs[index]} ($count)',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.05,
                      color: isActive
                          ? const Color(0xFF8B1E1E)
                          : colors.textOnSurfaceVariant,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 32),
        // Story List
        if (stories.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text(
                'No ${_tabs[_selectedTabIndex].toLowerCase()} stories yet.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: colors.textOnSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ...List.generate(stories.length, (index) {
            return _StoryCard(
              story: stories[index],
              colors: colors,
              index: index,
            );
          }),
      ],
    );
  }

  List<WriterStoryItem> _getStoriesForTab() {
    switch (_selectedTabIndex) {
      case 0:
        return widget.data.drafts;
      case 1:
        return widget.data.published;
      case 2:
        // Scheduled is not a separate API field; we show upcoming published
        return widget.data.recentStories
            .where(
              (s) =>
                  s.publishedAt != null &&
                  s.publishedAt!.isAfter(DateTime.now()),
            )
            .toList();
      default:
        return [];
    }
  }

  int _getTabCount(int index) {
    switch (index) {
      case 0:
        return widget.data.stats.draftCount;
      case 1:
        return widget.data.stats.publishedCount;
      case 2:
        return 0;
      default:
        return 0;
    }
  }
}

// ── Story Card ──────────────────────────────────────────────────────

class _StoryCard extends StatelessWidget {
  final WriterStoryItem story;
  final AppColors colors;
  final int index;

  const _StoryCard({
    required this.story,
    required this.colors,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;
    final timeAgo = _timeAgo(story.updatedAt);

    return Container(
      margin: EdgeInsets.only(bottom: index < _getStoryCount() - 1 ? 32 : 0),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x05000000),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: story.imageUrl != null
                        ? Image.network(
                            story.imageUrl!,
                            width: 256,
                            height: 160,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _PlaceholderImage(),
                          )
                        : _PlaceholderImage(),
                  ),
                  const SizedBox(width: 24),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: _StoryCardContent(
                        story: story,
                        colors: colors,
                        timeAgo: timeAgo,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image (full width on mobile)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: story.imageUrl != null
                        ? Image.network(
                            story.imageUrl!,
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _PlaceholderImage(),
                          )
                        : _PlaceholderImage(),
                  ),
                  const SizedBox(height: 16),
                  _StoryCardContent(
                    story: story,
                    colors: colors,
                    timeAgo: timeAgo,
                  ),
                ],
              ),
      ),
    );
  }

  // The count is available from the stories list length in parent
  // Just return a large number so margin works for all items
  int _getStoryCount() => 100;
}

class _StoryCardContent extends StatelessWidget {
  final WriterStoryItem story;
  final AppColors colors;
  final String timeAgo;

  const _StoryCardContent({
    required this.story,
    required this.colors,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status Badge + Last Edit
        Row(
          children: [
            _StatusBadge(status: story.status, colors: colors),
            const SizedBox(width: 12),
            Text(
              'Last edited $timeAgo',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: colors.textOnSurfaceVariant,
                height: 16 / 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Title
        Text(
          story.title,
          style: TextStyle(
            fontFamily: 'EB Garamond',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: colors.onBackground,
            height: 32 / 24,
          ),
        ),
        const SizedBox(height: 8),
        // Excerpt
        if (story.excerpt != null && story.excerpt!.isNotEmpty)
          Text(
            story.excerpt!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: colors.textOnSurfaceVariant,
              height: 24 / 16,
            ),
          ),
        const SizedBox(height: 16),
        // Continue Writing link
        InkWell(
          onTap: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Continue Writing',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.05,
                  color: const Color(0xFF8B1E1E),
                  decoration: TextDecoration.underline,
                  decorationColor: const Color(0xFF8B1E1E),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward,
                size: 16,
                color: const Color(0xFF8B1E1E),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Status Badge ────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  final AppColors colors;

  const _StatusBadge({required this.status, required this.colors});

  @override
  Widget build(BuildContext context) {
    final isDraft = status == 'Draft';
    final bgColor = isDraft ? const Color(0xFFF2E8E8) : const Color(0xFFE8F5E9);
    final textColor = isDraft
        ? const Color(0xFF8B1E1E)
        : const Color(0xFF2E7D32);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: textColor,
        ),
      ),
    );
  }
}

// ── Placeholder Image ───────────────────────────────────────────────

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E2DC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          Icons.image_rounded,
          size: 48,
          color: const Color(0xFF8B716E),
        ),
      ),
    );
  }
}

// ── Mobile Bottom Navigation ────────────────────────────────────────

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
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(top: BorderSide(color: colors.outlineVariant)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BottomNavItem(
                  icon: Icons.edit_note_rounded,
                  label: 'Drafts',
                  isActive: true,
                  colors: colors,
                ),
                _BottomNavItem(
                  icon: Icons.history_edu_rounded,
                  label: 'Published',
                  colors: colors,
                ),
                _BottomNavItem(
                  icon: Icons.schedule_rounded,
                  label: 'Scheduled',
                  colors: colors,
                ),
                _BottomNavItem(
                  icon: Icons.analytics_rounded,
                  label: 'SEO',
                  colors: colors,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final AppColors colors;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isActive ? colors.primary : colors.textOnSurfaceVariant,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? colors.primary : colors.textOnSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ─────────────────────────────────────────────────────────

String _formatNumber(int number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  }
  return number.toString();
}

String _timeAgo(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
  if (diff.inHours < 24) return '${diff.inHours} hours ago';
  if (diff.inDays < 7) return '${diff.inDays} days ago';
  return '${diff.inDays ~/ 7} weeks ago';
}
