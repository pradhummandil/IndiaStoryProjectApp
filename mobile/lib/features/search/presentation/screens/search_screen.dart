import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/story.dart';
import '../../../../design_system/app_colors.dart';
import '../../domain/models/search_models.dart';
import '../providers/search_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late FocusNode _searchFocus;
  String _selectedCategory = 'All Stories';
  final List<String> _categories = [
    'All Stories',
    'UNESCO Sites',
    'Wildlife',
    'Culinary Trails',
    'Arts & Crafts',
    'Architecture',
  ];

  @override
  void initState() {
    super.initState();
    _searchFocus = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    ref.read(searchQueryProvider.notifier).setQuery(query);
    _searchFocus.unfocus();
  }

  void _onCategoryChanged(String cat) {
    setState(() => _selectedCategory = cat);
    ref
        .read(searchQueryProvider.notifier)
        .setCategory(cat == 'All Stories' ? null : cat);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final searchState = ref.watch(searchQueryProvider);
    final hasQuery = searchState.query.isNotEmpty;
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F3),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  _TopAppBar(
                    colors: colors,
                    isDesktop: isDesktop,
                    searchController: _searchController,
                    searchFocus: _searchFocus,
                    onSearch: _onSearch,
                  ),
                  Expanded(
                    child: _SearchBody(
                      colors: colors,
                      isDesktop: isDesktop,
                      searchController: _searchController,
                      searchFocus: _searchFocus,
                      onSearch: _onSearch,
                      hasQuery: hasQuery,
                      selectedCategory: _selectedCategory,
                      categories: _categories,
                      onCategoryChanged: _onCategoryChanged,
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
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFFFCF9F3),
          border: Border(
            top: BorderSide(
              color: const Color(0xFFDFBFBC).withValues(alpha: 0.3),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.auto_stories_rounded, 'Discover', false, colors),
            _navItem(Icons.search_rounded, 'Explore', true, colors),
            _navItem(Icons.museum_rounded, 'Library', false, colors),
            _navItem(Icons.bookmark_rounded, 'Saved', false, colors),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active, AppColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: active ? colors.primary : colors.secondary,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: active ? colors.primary : colors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopAppBar extends StatelessWidget {
  final AppColors colors;
  final bool isDesktop;
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final ValueChanged<String> onSearch;

  const _TopAppBar({
    required this.colors,
    required this.isDesktop,
    required this.searchController,
    required this.searchFocus,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFCF9F3).withValues(alpha: 0.95),
          border: Border(bottom: BorderSide(color: const Color(0xFFDFBFBC))),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
          child: Row(
            children: [
              Text(
                'HERITAGE',
                style: TextStyle(
                  fontFamily: 'EB Garamond',
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                  color: colors.primary,
                  height: 40 / 32,
                ),
              ),
              const SizedBox(width: 48),
              _DesktopNavLink(label: 'Archive', active: false, colors: colors),
              const SizedBox(width: 24),
              _DesktopNavLink(label: 'Search', active: true, colors: colors),
              const SizedBox(width: 24),
              _DesktopNavLink(
                label: 'Collections',
                active: false,
                colors: colors,
              ),
              const SizedBox(width: 24),
              _DesktopNavLink(label: 'Account', active: false, colors: colors),
              const Spacer(),
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F3ED),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFDFBFBC)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 16,
                      color: const Color(0xFF635D5A),
                    ),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: searchController,
                        focusNode: searchFocus,
                        decoration: const InputDecoration(
                          hintText: 'Quick find...',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        onSubmitted: onSearch,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.history_rounded, size: 20),
                color: const Color(0xFF58413F),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 20),
                color: const Color(0xFF58413F),
                onPressed: () {},
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E2DC),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFDFBFBC)),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person_rounded,
                    size: 16,
                    color: Color(0xFF635D5A),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFFCF9F3),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFDFBFBC).withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          InkWell(
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Icon(Icons.menu_rounded, color: colors.primary, size: 24),
            ),
          ),
          const Spacer(),
          Text(
            'HERITAGE',
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
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Icon(
                  Icons.tune_rounded,
                  color: colors.primary,
                  size: 24,
                ),
              ),
            ),
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: active
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF6A020A), width: 2),
              ),
            )
          : null,
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          letterSpacing: 0.05,
          color: active ? colors.primary : const Color(0xFF635D5A),
          height: 20 / 14,
        ),
      ),
    );
  }
}

class _SearchBody extends ConsumerWidget {
  final AppColors colors;
  final bool isDesktop;
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final ValueChanged<String> onSearch;
  final bool hasQuery;
  final String selectedCategory;
  final List<String> categories;
  final ValueChanged<String> onCategoryChanged;

  const _SearchBody({
    required this.colors,
    required this.isDesktop,
    required this.searchController,
    required this.searchFocus,
    required this.onSearch,
    required this.hasQuery,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queryState = ref.watch(searchQueryProvider);
    if (isDesktop) {
      return _DesktopLayout(
        colors: colors,
        queryState: queryState,
        searchController: searchController,
        onSearch: onSearch,
        categories: categories,
        selectedCategory: selectedCategory,
        onCategoryChanged: onCategoryChanged,
      );
    }
    return _MobileLayout(
      colors: colors,
      queryState: queryState,
      searchController: searchController,
      searchFocus: searchFocus,
      onSearch: onSearch,
      categories: categories,
    );
  }
}

class _DesktopLayout extends ConsumerWidget {
  final AppColors colors;
  final SearchQueryState queryState;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const _DesktopLayout({
    required this.colors,
    required this.queryState,
    required this.searchController,
    required this.onSearch,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(searchResultsProvider);
    final trendingAsync = ref.watch(trendingSearchesProvider);
    final recentAsync = ref.watch(recentSearchesProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(64, 48, 64, 48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CATEGORIES',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.05,
                    color: const Color(0xFF1C1C18),
                    height: 20 / 14,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((cat) {
                    final isSelected = cat == selectedCategory;
                    return GestureDetector(
                      onTap: () => onCategoryChanged(cat),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.primary
                              : const Color(0xFFE5E2DC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF58413F),
                            height: 16 / 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EEE8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDFBFBC)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.auto_stories_rounded,
                        size: 24,
                        color: colors.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Archival Access',
                        style: TextStyle(
                          fontFamily: 'EB Garamond',
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1C1C18),
                          height: 32 / 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Unlock premium historical manuscripts and rare photographs with a Research Account.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF67625E),
                          height: 24 / 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colors.primary,
                            side: const BorderSide(
                              color: Color(0xFF6A020A),
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Apply for Access',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFDFBFBC)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D2D2926),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        size: 28,
                        color: Color(0xFF6A020A),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            hintText: "Discover India's hidden narratives...",
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 28),
                          ),
                          style: const TextStyle(
                            fontFamily: 'EB Garamond',
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            height: 32 / 24,
                          ),
                          onSubmitted: onSearch,
                        ),
                      ),
                      const SizedBox(width: 16),
                      FilledButton(
                        onPressed: () => onSearch(searchController.text),
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Search',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.05,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.history_rounded,
                                size: 14,
                                color: const Color(0xFF635D5A),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'RECENT SEARCHES',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.05,
                                  color: const Color(0xFF635D5A),
                                  height: 20 / 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          recentAsync.when(
                            data: (items) => Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: items.take(5).map((item) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEBE8E2),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    item.query,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF58413F),
                                      height: 16 / 12,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.trending_up_rounded,
                                size: 14,
                                color: const Color(0xFF635D5A),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'TRENDING TOPICS',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.05,
                                  color: const Color(0xFF635D5A),
                                  height: 20 / 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          trendingAsync.when(
                            data: (items) => Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: items.take(5).map((item) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEBE8E2),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    item.query,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF58413F),
                                      height: 16 / 12,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                resultsAsync.when(
                  data: (data) => _ResultsSection(data: data, colors: colors),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cloud_off_rounded,
                            size: 48,
                            color: colors.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Could not load results',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: colors.onBackground,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error.toString(),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: colors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () =>
                                ref.invalidate(searchResultsProvider),
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
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

class _ResultsSection extends StatelessWidget {
  final FullSearchResponse data;
  final AppColors colors;

  const _ResultsSection({required this.data, required this.colors});

  @override
  Widget build(BuildContext context) {
    final items = data.storyItems;

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 64,
                color: const Color(0xFF8B716E).withValues(alpha: 0.4),
              ),
              const SizedBox(height: 16),
              Text(
                'No results found',
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
                'Try adjusting your search terms or filters',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: colors.onSurfaceVariant,
                  height: 24 / 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Search Results (${data.totalStories})',
              style: TextStyle(
                fontFamily: 'EB Garamond',
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: colors.onBackground,
                height: 40 / 32,
              ),
            ),
            Row(
              children: [
                Text(
                  'Sort by: ',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF635D5A),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDFBFBC)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Relevance',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6A020A),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Column(
          children: items.map((item) {
            // item is already a StoryListItem or Map<String, dynamic>
            // Use toJson() to convert to Map for the card
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _StoryCard(item: item, colors: colors),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _StoryCard extends StatelessWidget {
  final dynamic item;
  final AppColors colors;

  const _StoryCard({required this.item, required this.colors});

  String? _getImageUrl() {
    if (item is Map<String, dynamic>) {
      return (item as Map)['imageUrl'] as String?;
    }
    try {
      return (item as dynamic).imageUrl as String?;
    } catch (_) {
      return null;
    }
  }

  String _getTitle() {
    if (item is Map<String, dynamic>) {
      return (item as Map)['title'] as String? ?? 'Untitled';
    }
    try {
      return (item as dynamic).title as String? ?? 'Untitled';
    } catch (_) {
      return 'Untitled';
    }
  }

  String _getCategory() {
    if (item is Map<String, dynamic>) {
      final tags = (item as Map)['tags'] as List<dynamic>? ?? [];
      if (tags.isNotEmpty && tags.first is Map) {
        return (tags.first as Map)['name'] as String? ?? 'Heritage';
      }
    }
    try {
      final tags = (item as dynamic).tags as List? ?? [];
      if (tags.isNotEmpty) {
        return tags.first.name as String? ?? 'Heritage';
      }
    } catch (_) {}
    return 'Heritage';
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFE5E2DC),
      child: const Center(
        child: Icon(Icons.image_rounded, size: 48, color: Color(0xFF8B716E)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _getTitle();
    final imageUrl = _getImageUrl();
    final category = _getCategory();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E1D8)),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            SizedBox(
              width: 256,
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      width: 256,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.toString().toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        color: colors.primary,
                        height: 16 / 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        title,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileLayout extends ConsumerWidget {
  final AppColors colors;
  final SearchQueryState queryState;
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final ValueChanged<String> onSearch;
  final List<String> categories;

  const _MobileLayout({
    required this.colors,
    required this.queryState,
    required this.searchController,
    required this.searchFocus,
    required this.onSearch,
    required this.categories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(searchResultsProvider);
    final trendingAsync = ref.watch(trendingSearchesProvider);
    final recentAsync = ref.watch(recentSearchesProvider);
    final hasQuery = queryState.query.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFDFBFBC).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(
                  Icons.search_rounded,
                  size: 24,
                  color: const Color(0xFF8B716E),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    focusNode: searchFocus,
                    decoration: const InputDecoration(
                      hintText: "Explore India's chronicles...",
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 24 / 16,
                    ),
                    onSubmitted: onSearch,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (!hasQuery) ...[
            SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E2DC),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        cat,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.05,
                          color: Color(0xFF58413F),
                          height: 20 / 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'RECENT JOURNEYS',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.05,
                        color: colors.onSurfaceVariant,
                        height: 20 / 14,
                      ),
                    ),
                    InkWell(
                      onTap: () => ref.read(clearSearchHistoryProvider.future),
                      child: Text(
                        'Clear All',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colors.primary,
                          height: 16 / 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                recentAsync.when(
                  data: (items) => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: items.take(5).map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F3ED),
                          border: Border.all(color: const Color(0x4DDFBFBC)),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.query,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: colors.onSurface,
                                height: 20 / 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => ref.read(
                                deleteSearchHistoryItemProvider(item.id).future,
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                size: 16,
                                color: const Color(0xFF8B716E),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TRENDING ARCHIVES',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.05,
                    color: colors.onSurfaceVariant,
                    height: 20 / 14,
                  ),
                ),
                const SizedBox(height: 16),
                trendingAsync.when(
                  data: (items) => Column(
                    children: items.take(5).toList().asMap().entries.map((
                      entry,
                    ) {
                      final topic = entry.value;
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0x33DFBFBC)),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 32,
                              child: Text(
                                '${entry.key + 1}',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: colors.primary,
                                  height: 20 / 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                topic.query,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1C1C18),
                                  height: 24 / 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ],
          if (hasQuery) ...[
            const SizedBox(height: 16),
            resultsAsync.when(
              data: (data) => _ResultsSection(data: data, colors: colors),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_off_rounded,
                        size: 48,
                        color: colors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Could not load results',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: colors.onBackground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: colors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => ref.invalidate(searchResultsProvider),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
