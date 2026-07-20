import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/profile_screen_data.dart';
import '../providers/profile_providers.dart';
import '../widgets/profile_bottom_nav.dart';
import '../widgets/profile_top_app_bar.dart';
import '../widgets/profile_header_section.dart';
import '../widgets/profile_badges_section.dart';
import '../widgets/profile_collections_section.dart';
import '../widgets/profile_recent_discoveries_section.dart';

/// Profile Screen.
///
/// Matches `design/user_profile/code.html` exactly.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileScreenDataProvider);
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5EF), // bg-background
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  const ProfileTopAppBar(),
                  Expanded(
                    child: profileAsync.when(
                      data: (data) => _ProfileBody(data: data),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => _ProfileErrorRetry(
                        message: error.toString(),
                        onRetry: () =>
                            ref.invalidate(profileScreenDataProvider),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!isDesktop) const ProfileBottomNav(),
          ],
        ),
      ),
    );
  }
}

class _ProfileErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ProfileErrorRetry({required this.message, required this.onRetry});

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
              'Could not load profile',
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

class _ProfileBody extends StatelessWidget {
  final ProfileScreenData data;

  const _ProfileBody({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: isDesktop ? 64 : 20,
        right: isDesktop ? 64 : 20,
        top: 32,
        bottom: isDesktop ? 32 : 96,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProfileHeaderSection(),
          const ProfileBadgesSection(),
          const ProfileCollectionsSection(),
          const ProfileRecentDiscoveriesSection(),
        ],
      ),
    );
  }
}
