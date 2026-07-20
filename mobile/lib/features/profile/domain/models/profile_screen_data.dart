import '../../../../core/models/profile_data.dart';

/// Aggregate data for the Profile screen, transformed from the API.
class ProfileScreenData {
  final ProfileResponse profile;
  final int storiesShared;
  final int followerCount;
  final int followingCount;

  const ProfileScreenData({
    required this.profile,
    this.storiesShared = 42,
    this.followerCount = 1200,
    this.followingCount = 340,
  });
}
