import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/app_colors.dart';
import '../../../../design_system/app_shadows.dart';
import '../../../../core/models/story.dart';
import '../../domain/models/search_models.dart';
import '../providers/search_providers.dart';

/// Search Screen — matches `design/search_mobile/code.html` and `design/search_desktop/code.html` exactly.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late FocusNode _searchFocus;
  bool _showDesktopFilters = true;
  List<String> _categories = [
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

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final isTablet = MediaQuery.of(context).size.width >= 600 && !isDesktop;
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
                    onToggleFilters: () =>
                        setState(() => _showDesktopFilters = !_showDesktopFilters),
                  ),
                  Expanded(
                    child: _SearchBody(
                      colors: colors,
                      isDesktop: isDesktop,
                      isTablet: isTablet,
                      searchController: _searchController,
                      searchFocus: _searchFocus,
                      onSearch: _onSearch,
                      hasQuery: hasQuery,
                      showDesktopFilters: _showDesktopFilters,
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

// ── TopAppBar ─────────────────────────────────────────────────────────

// ── TopAppBar ─────────────────────────────────────────────────────────

class _TopAppBar extends ConsumerWidget {
  final AppColors colors;
  final bool isDesktop;
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final ValueChanged<String> onSearch;
  final VoidCallback onToggleFilters;

  const _TopAppBar({
    required this.colors,
    required this.isDesktop,
    required this.searchController,
    required this.searchFocus,
    required this.onSearch,
    required this.onToggleFilters,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFCF9F3).withValues(alpha: 0.95),
          border: Border(bottom: BorderSide(color: const Color(0xFFDFBFBC))),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
              child: Row(
                children: [
                  Text('HERITAGE', style: TextStyle(
                    fontFamily: 'EB Garamond', fontSize: 32, fontWeight: FontWeight.w500,
                    letterSpacing: 2, color: colors.primary, height: 40 / 32,
                  )),
                  const SizedBox(width: 48),
                  _DesktopNavLink(label: 'Archive', active: false, colors: colors),
                  const SizedBox(width: 24),
                  _DesktopNavLink(label: 'Search', active: true, colors: colors),
                  const SizedBox(width: 24),
                  _DesktopNavLink(label: 'Collections', active: false, colors: colors),
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
                        Icon(Icons.search_rounded, size: 16, color: const Color(0xFF635D5A)),
                        const SizedBox(width: 4),
                        SizedBox(width: 100, child: TextField(
                          controller: searchController, focusNode: searchFocus,
                          decoration: const InputDecoration(
                            hintText: 'Quick find...', border: InputBorder.none,
                            isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500),
                          onSubmitted: onSearch,
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(icon: const Icon(Icons.history_rounded, size: 20), color: const Color(0xFF58413F), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.notifications_outlined, size: 20), color: const Color(0xFF58413F), onPressed: () {}),
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(color: const Color(0xFFE5E2DC), shape: BoxShape.circle, border: Border.all(color: const Color(0xFFDFBFBC))),
                    child: const Center(child: Icon(Icons.person_rounded, size: 16, color: Color(0xFF635D5A))),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    // Mobile
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFFCF9F3),
        border: Border(bottom: BorderSide(color: const Color(0xFFDFBFBC).withValues(alpha: 0.3))),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          InkWell(onTap: () {}, child: Container(width: 40, height: 40, alignment: Alignment.center,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCF9F3).withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(color: const Color(0xFFDFBFBC)),
        ),
      ),
      child: Column(
        children: [
          Container(
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
                _DesktopNavLink(
                  label: 'Archive',
                  active: false,
                  colors: colors,
                ),
                const SizedBox(width: 24),
                _DesktopNavLink(
                  label: 'Search',
                  active: true,
                  colors: colors,
                ),
                const SizedBox(width: 24),
                _DesktopNavLink(
                  label: 'Collections',
                  active: false,
                  colors: colors,
                ),
                const SizedBox(width: 24),
                _DesktopNavLink(
                  label: 'Account',
                  active: false,
                  colors: colors,
                ),
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

// ── Search Body ──────────────────────────────────────────────────────

class _SearchBody extends ConsumerWidget {
  final AppColors colors;
  final bool isDesktop;
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final ValueChanged<String> onSearch;
  final bool hasQuery;
  final bool showDesktopFilters;
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
    required this.showDesktopFilters,
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
        showFilters: showDesktopFilters,
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

// ── Desktop Layout ───────────────────────────────────────────────────

class _DesktopLayout extends ConsumerWidget {
  final AppColors colors;
  final SearchQueryState queryState;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final bool showFilters;

  const _DesktopLayout({
    required this.colors,
    required this.queryState,
    required this.searchController,
    required this.onSearch,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.showFilters,
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
          // Left column: Filters
          SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categories
                Column(
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
                            side: const BorderSide(color: Color(0xFF6A020A), width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Apply for Access', style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
          // Right column: Search & Results
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Central search bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFDFBFBC)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x0D2D2926),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, size: 28, color: Color(0xFF6A020A)),
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
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Search', style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.05,
                        )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Recent & Trending chips
                Row(
                  children: [
                    // Recent Searches
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.history_rounded, size: 14, color: const Color(0xFF635D5A)),
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
                              children: items.take(5).map((item) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEBE8E2),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(item.query, style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF58413F),
                                  height: 16 / 12,
                                )),
                              )).toList(),
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Trending Topics
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.trending_up_rounded, size: 14, color: const Color(0xFF635D5A)),
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
                              children: items.take(5).map((item) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEBE8E2),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(item.query, style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF58413F),
                                  height: 16 / 12,
                                )),
                              )).toList(),
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
                // Results
                resultsAsync.when(
                  data: (data) => _ResultsSection(
                    data: data,
                    colors: colors,
                    isDesktop: true,
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(Icons.cloud_off_rounded, size: 48, color: colors.error),
                          const SizedBox(height: 16),
                          Text('Could not load results', style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: colors.onBackground,
                          )),
                          const SizedBox(height: 8),
                          Text(error.toString(), style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: colors.onSurfaceVariant,
                          ), textAlign: TextAlign.center),
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
            ),
          ),
        ],
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
          // Search input
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFDFBFBC).withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x0A000000),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(Icons.search_rounded, size: 24, color: const Color(0xFF8B716E)),
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

          // Categories scroll
          if (!hasQuery) ...[
            SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories.map((cat) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E2DC),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(cat, style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.05,
                      color: Color(0xFF58413F),
                      height: 20 / 14,
                    )),
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 32),

            // Recent Searches
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
