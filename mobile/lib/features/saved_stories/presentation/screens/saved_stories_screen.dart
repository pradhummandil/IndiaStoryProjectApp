import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/app_colors.dart';
import '../../domain/models/saved_story_models.dart';
import '../providers/saved_stories_providers.dart';

/// Saved Stories Screen.
///
/// Matches `design/saved_stories/code.html` exactly.
class SavedStoriesScreen extends ConsumerStatefulWidget {
  const SavedStoriesScreen({super.key});

  @override
  ConsumerState<SavedStoriesScreen> createState() => _SavedStoriesScreenState();
}

class _SavedStoriesScreenState extends ConsumerState<SavedStoriesScreen> {
  bool _isGridView = true;
  String _searchQuery = '';
  String _selectedCategory = 'All Collections';

  final List<String> _categories = const [
    'All Collections',
    'Architecture',
    'Mughal Era',
    'Post-Independence',
    'Folk Culture',
    'Oral Histories',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F3),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  _TopAppBar(colors: colors, isDesktop: isDesktop),
                  Expanded(
                    child: ref
                        .watch(savedStoriesProvider)
                        .when(
                          data: (data) => _SavedStoriesBody(
                            data: data,
                            colors: colors,
                            isDesktop: isDesktop,
                            isGridView: _isGridView,
                            onToggleView: () =>
                                setState(() => _isGridView = !_isGridView),
                            selectedCategory: _selectedCategory,
                            categories: _categories,
                            onCategoryChanged: (cat) =>
                                setState(() => _selectedCategory = cat),
                            searchQuery: _searchQuery,
                            onSearchChanged: (q) =>
                                setState(() => _searchQuery = q),
                            onRemoveBookmark: _removeBookmark,
                          ),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, stack) => _ErrorRetry(
                            message: error.toString(),
                            onRetry: () => ref.invalidate(savedStoriesProvider),
                          ),
                        ),
                  ),
                ],
              ),
            ),
            if (!isDesktop) _MobileBottomNav(colors: colors),
          ],
        ),
      ),
    );
  }

  Future<void> _removeBookmark(String storyId) async {
    await ref.read(removeBookmarkProvider(storyId).future);
    ref.invalidate(savedStoriesProvider);
  }
}

class _TopAppBar extends StatelessWidget {
  final AppColors colors;
  final bool isDesktop;

  const _TopAppBar({required this.colors, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFFCF9F3),
        border: Border(bottom: BorderSide(color: const Color(0xFFE5E1D8))),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Icon(Icons.menu_rounded, color: colors.primary, size: 24),
            ),
          ),
          const Spacer(),
          Text(
            'INDIA STORY',
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: colors.primary,
              height: 32 / 24,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Icon(
                  Icons.search_rounded,
                  color: colors.primary,
                  size: 24,
                ),
              ),
            ),
          ),
          if (isDesktop) ...[
            const SizedBox(width: 8),
            _DesktopNavLink(label: 'Archive', active: false, colors: colors),
            const SizedBox(width: 8),
            _DesktopNavLink(label: 'Saved', active: true, colors: colors),
            const SizedBox(width: 64),
          ],
        ],
      ),
    );
  }
}

class _DesktopNavLink extends StatelessWidget {
  final String label;
  final bool active;
  final AppColors colors;

  const _DesktopNavLink({
    required this.label,
    required this.active,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: active
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF8B1E1E), width: 4),
              ),
            )
          : null,
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 2,
          color: active ? colors.primary : colors.onSurfaceVariant,
          height: 16 / 12,
        ),
      ),
    );
  }
}

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
              'Could not load saved stories',
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

class _SavedStoriesBody extends StatelessWidget {
  final BookmarksResponse data;
  final AppColors colors;
  final bool isDesktop;
  final bool isGridView;
  final VoidCallback onToggleView;
  final String selectedCategory;
  final List<String> categories;
  final ValueChanged<String> onCategoryChanged;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final Future<void> Function(String storyId) onRemoveBookmark;

  const _SavedStoriesBody({
    required this.data,
    required this.colors,
    required this.isDesktop,
    required this.isGridView,
    required this.onToggleView,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onRemoveBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: isDesktop ? 64 : 16,
        right: isDesktop ? 64 : 16,
        top: 96,
        bottom: isDesktop ? 32 : 96,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SearchFilterBar(
                colors: colors,
                isGridView: isGridView,
                onToggleView: onToggleView,
                searchQuery: searchQuery,
                onSearchChanged: onSearchChanged,
              ),
              const SizedBox(height: 32),
              _CategoriesRow(
                categories: categories,
                selectedCategory: selectedCategory,
                onCategoryChanged: onCategoryChanged,
                colors: colors,
              ),
              const SizedBox(height: 32),
              if (data.items.isEmpty)
                _EmptyState(colors: colors)
              else
                _StoriesGrid(
                  items: data.items,
                  colors: colors,
                  isGridView: isGridView,
                  onRemoveBookmark: onRemoveBookmark,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchFilterBar extends StatelessWidget {
  final AppColors colors;
  final bool isGridView;
  final VoidCallback onToggleView;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  const _SearchFilterBar({
    required this.colors,
    required this.isGridView,
    required this.onToggleView,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 768;
        return Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E1D8)),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: onSearchChanged,
                        decoration: const InputDecoration(
                          hintText: 'Search your archive...',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E1D8)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 20,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Filters',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.05,
                      color: colors.onSurfaceVariant,
                      height: 20 / 14,
                    ),
                  ),
                ],
              ),
            ),
            if (isWide) ...[
              const SizedBox(width: 12),
              Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EEE8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E1D8)),
                ),
                child: Row(
                  children: [
                    _ViewToggleButton(
                      icon: Icons.grid_view_rounded,
                      isActive: isGridView,
                      onTap: isGridView ? null : onToggleView,
                      activeColor: colors.primary,
                    ),
                    _ViewToggleButton(
                      icon: Icons.view_list_rounded,
                      isActive: !isGridView,
                      onTap: isGridView ? onToggleView : null,
                      activeColor: colors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _ViewToggleButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;
  final Color activeColor;

  const _ViewToggleButton({
    required this.icon,
    required this.isActive,
    this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? activeColor : const Color(0xFF635D5A),
        ),
      ),
    );
  }
}

class _CategoriesRow extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final AppColors colors;

  const _CategoriesRow({
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: categories.map((cat) {
          final isSelected = cat == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => onCategoryChanged(cat),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : const Color(0xFFE5E2DC),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : colors.onSurfaceVariant,
                    height: 16 / 12,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppColors colors;

  const _EmptyState({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEE8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              size: 64,
              color: const Color(0xFF8B716E).withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your personal archive awaits.',
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: colors.onBackground,
              height: 40 / 32,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Discover stories of our shared heritage and save them here\nto curate your own historical journey.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: colors.onSurfaceVariant,
              height: 28 / 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'EXPLORE STORIES',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoriesGrid extends StatelessWidget {
  final List<BookmarkItem> items;
  final AppColors colors;
  final bool isGridView;
  final Future<void> Function(String storyId) onRemoveBookmark;

  const _StoriesGrid({
    required this.items,
    required this.colors,
    required this.isGridView,
    required this.onRemoveBookmark,
  });

  @override
  Widget build(BuildContext context) {
    if (isGridView) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width >= 1024
              ? 3
              : MediaQuery.of(context).size.width >= 600
              ? 2
              : 1,
          mainAxisExtent: 420,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => _StoryCard(
          item: items[index],
          colors: colors,
          isGridView: true,
          onRemoveBookmark: onRemoveBookmark,
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _StoryCard(
        item: items[index],
        colors: colors,
        isGridView: false,
        onRemoveBookmark: onRemoveBookmark,
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final BookmarkItem item;
  final AppColors colors;
  final bool isGridView;
  final Future<void> Function(String storyId) onRemoveBookmark;

  const _StoryCard({
    required this.item,
    required this.colors,
    required this.isGridView,
    required this.onRemoveBookmark,
  });

  String _formatDate(DateTime dt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  @override
  Widget build(BuildContext context) {
    final story = item.story;
    final categoryTag = story.tags.isNotEmpty
        ? story.tags.first.name
        : 'Heritage';

    if (isGridView) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E1D8)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 192,
              width: double.infinity,
              child: Stack(
                children: [
                  if (story.imageUrl != null)
                    Image.network(
                      story.imageUrl!,
                      width: double.infinity,
                      height: 192,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imagePlaceholder(),
                    )
                  else
                    _imagePlaceholder(),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: InkWell(
                      onTap: () => onRemoveBookmark(item.storyId),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.bookmark_rounded,
                          size: 18,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 4,
                      color: const Color(0xFFE5E2DC),
                      child: const FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.0,
                        child: SizedBox(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          categoryTag.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            color: Color(0xFF6A020A),
                            height: 16 / 12,
                          ),
                        ),
                        Text(
                          'Saved ${_formatDate(item.createdAt)}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF635D5A),
                            height: 16 / 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        story.title,
                        style: const TextStyle(
                          fontFamily: 'EB Garamond',
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1C1C18),
                          height: 32 / 24,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Color(0xFFDFBFBC)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE5E2DC),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  size: 12,
                                  color: Color(0xFF635D5A),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                story.author?.name ?? 'Unknown',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF635D5A),
                                  height: 16 / 12,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule_rounded,
                                size: 14,
                                color: Color(0xFF635D5A),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${story.readingTime ?? 5} min read',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF635D5A),
                                  height: 16 / 12,
                                ),
                              ),
                            ],
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E1D8)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(
            width: 256,
            child: Stack(
              children: [
                if (story.imageUrl != null)
                  Image.network(
                    story.imageUrl!,
                    width: 256,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePlaceholder(),
                  )
                else
                  _imagePlaceholder(),
                Positioned(
                  top: 12,
                  right: 12,
                  child: InkWell(
                    onTap: () => onRemoveBookmark(item.storyId),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bookmark_rounded,
                        size: 18,
                        color: colors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        categoryTag.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                          color: Color(0xFF6A020A),
                          height: 16 / 12,
                        ),
                      ),
                      Text(
                        'Saved ${_formatDate(item.createdAt)}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF635D5A),
                          height: 16 / 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      story.title,
                      style: const TextStyle(
                        fontFamily: 'EB Garamond',
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1C1C18),
                        height: 32 / 24,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Color(0xFFDFBFBC))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE5E2DC),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                size: 12,
                                color: Color(0xFF635D5A),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              story.author?.name ?? 'Unknown',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF635D5A),
                                height: 16 / 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              size: 14,
                              color: Color(0xFF635D5A),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${story.readingTime ?? 5} min read',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF635D5A),
                                height: 16 / 12,
                              ),
                            ),
                          ],
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

  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xFFE5E2DC),
      child: const Center(
        child: Icon(Icons.image_rounded, size: 48, color: Color(0xFF8B716E)),
      ),
    );
  }
}

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
          color: const Color(0xFFFCF9F3),
          border: Border(top: BorderSide(color: const Color(0xFFDFBFBC))),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                active: false,
                colors: colors,
              ),
              _BottomNavItem(
                icon: Icons.explore_rounded,
                label: 'Explore',
                active: false,
                colors: colors,
              ),
              _BottomNavItem(
                icon: Icons.share_rounded,
                label: 'Share',
                active: false,
                colors: colors,
              ),
              _BottomNavItem(
                icon: Icons.bookmark_rounded,
                label: 'Saved',
                active: true,
                colors: colors,
              ),
              _BottomNavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
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

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final AppColors colors;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFF2E8E8) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
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
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: active ? colors.primary : colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
