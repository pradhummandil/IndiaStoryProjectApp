import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/app_colors.dart';
import '../../domain/models/history_models.dart';
import '../providers/history_providers.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyProvider.notifier).loadHistory();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(historyProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final state = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F3),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopAppBar(colors: colors),
            _SearchBar(
              controller: _searchController,
              colors: colors,
              onSearch: (q) {
                ref.read(historyProvider.notifier).setSearch(q);
              },
            ),
            _FilterBar(
              selectedFilter: state.filter,
              colors: colors,
              onFilterChanged: (f) {
                ref.read(historyProvider.notifier).setFilter(f);
              },
            ),
            Expanded(child: _buildContent(state, colors)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(HistoryState state, AppColors colors) {
    if (state.isLoading && state.items.isEmpty) {
      return const _LoadingState();
    }
    if (state.error != null && state.items.isEmpty) {
      return _ErrorState(
        message: state.error!,
        onRetry: () => ref.read(historyProvider.notifier).refresh(),
        colors: colors,
      );
    }
    if (state.items.isEmpty) {
      return _EmptyState(colors: colors);
    }
    return RefreshIndicator(
      onRefresh: () async => ref.read(historyProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 96),
        itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.items.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          final item = state.items[index];
          final isFirstInGroup =
              index == 0 ||
              _getGroupLabel(state.items[index - 1].lastReadAt) !=
                  _getGroupLabel(item.lastReadAt);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isFirstInGroup)
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 12, left: 4),
                  child: _GroupLabel(
                    label: _getGroupLabel(item.lastReadAt),
                    colors: colors,
                  ),
                ),
              _HistoryItem(
                item: item,
                colors: colors,
                onDelete: () => ref
                    .read(historyProvider.notifier)
                    .deleteHistoryItem(item.storyId),
                onReadAgain: () {},
              ),
            ],
          );
        },
      ),
    );
  }

  String _getGroupLabel(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return 'Last Week';
    if (diff.inDays < 30) return 'Earlier';
    return 'Older';
  }
}

class _TopAppBar extends ConsumerWidget {
  final AppColors colors;
  const _TopAppBar({required this.colors});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          const SizedBox(width: 8),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_rounded,
                color: colors.primary,
                size: 24,
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Reading History',
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: colors.primary,
              letterSpacing: -0.02,
              height: 32 / 24,
            ),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: colors.primary),
            onSelected: (value) {
              if (value == 'clear') {
                ref.read(historyProvider.notifier).clearHistory();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'clear', child: Text('Clear History')),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final AppColors colors;
  final ValueChanged<String> onSearch;
  const _SearchBar({
    required this.controller,
    required this.colors,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E1D8)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(
              Icons.search_rounded,
              size: 20,
              color: const Color(0xFF635D5A),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onSearch,
                decoration: InputDecoration(
                  hintText: 'Search history...',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: const Color(0xFF635D5A).withValues(alpha: 0.6),
                  ),
                ),
                style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
              ),
            ),
            if (controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear_rounded, size: 18),
                onPressed: () {
                  controller.clear();
                  onSearch('');
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final String selectedFilter;
  final AppColors colors;
  final ValueChanged<String> onFilterChanged;
  const _FilterBar({
    required this.selectedFilter,
    required this.colors,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'key': 'all', 'label': 'All History'},
      {'key': 'today', 'label': 'Today'},
      {'key': 'week', 'label': 'Last 7 Days'},
      {'key': 'month', 'label': 'This Month'},
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFDFBFBC).withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((f) {
            final isSelected = f['key'] == selectedFilter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => onFilterChanged(f['key']!),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.primary
                        : const Color(0xFFE5E1D8),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    f['label']!,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF1C1C18),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  final String label;
  final AppColors colors;
  const _GroupLabel({required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colors.primary, width: 2),
            color: const Color(0xFFFCF9F3),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: colors.secondary,
            height: 16 / 12,
          ),
        ),
      ],
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final HistoryItem item;
  final AppColors colors;
  final VoidCallback onDelete;
  final VoidCallback onReadAgain;
  const _HistoryItem({
    required this.item,
    required this.colors,
    required this.onDelete,
    required this.onReadAgain,
  });

  String _formatDuration(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.month}/${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.storyId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: colors.error,
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E1D8)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.story.category,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF8B1E1E),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.story.title,
                    style: const TextStyle(
                      fontFamily: 'EB Garamond',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1C1C18),
                      height: 20 / 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color: const Color(0xFF635D5A),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.story.readingTime ?? 5} min read',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colors.secondary,
                          height: 16 / 12,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: const Color(0xFF635D5A),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDuration(item.lastReadAt),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colors.secondary,
                          height: 16 / 12,
                        ),
                      ),
                    ],
                  ),
                  if (item.progressPercent > 0 && !item.completed) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Container(
                        height: 4,
                        color: const Color(0xFFF0EEE8),
                        child: FractionallySizedBox(
                          widthFactor: item.progressPercent / 100,
                          child: Container(color: const Color(0xFF8B1E1E)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.progressPercent}% complete',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF635D5A),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: onReadAgain,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Read Again',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                    letterSpacing: 0.05,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E2DC),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E2DC),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EEE8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final AppColors colors;
  const _ErrorState({
    required this.message,
    required this.onRetry,
    required this.colors,
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
              'Could not load history',
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
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppColors colors;
  const _EmptyState({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF0EEE8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_rounded,
                size: 40,
                color: const Color(0xFF8B716E).withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No reading history yet',
              style: TextStyle(
                fontFamily: 'EB Garamond',
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: colors.onBackground,
                height: 32 / 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Stories you read will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: colors.onSurfaceVariant,
                height: 20 / 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
