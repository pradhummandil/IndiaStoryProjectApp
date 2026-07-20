import '../models/home_data.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';

class HomeRepository {
  final ApiClient _client;

  HomeRepository(this._client);

  /// Fetches all home screen data.
  Future<HomeResponse> getHome() async {
    final json = await _client.get(ApiConstants.home);
    return HomeResponse.fromJson(json as Map<String, dynamic>);
  }
}
