import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/providers.dart';
import '../../domain/models/profile_screen_data.dart';

/// Fetches the current user's profile from the backend API.
final profileScreenDataProvider = FutureProvider<ProfileScreenData>((
  ref,
) async {
  final repo = ref.watch(profileRepositoryProvider);
  final profile = await repo.getProfile();

  return ProfileScreenData(
    profile: profile,
    storiesShared: 42, // TODO: derive from backend when available
    followerCount: 1200, // TODO: derive from backend when available
    followingCount: 340, // TODO: derive from backend when available
  );
});
