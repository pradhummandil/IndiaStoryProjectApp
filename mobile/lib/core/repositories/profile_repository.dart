import '../models/profile_data.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';

class ProfileRepository {
  final ApiClient _client;

  ProfileRepository(this._client);

  /// Fetches the current user's profile.
  Future<ProfileResponse> getProfile() async {
    final json = await _client.get(ApiConstants.profile);
    return ProfileResponse.fromJson(json as Map<String, dynamic>);
  }
}
