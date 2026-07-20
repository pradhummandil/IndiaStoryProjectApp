import '../models/home_data.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';

class CategoryRepository {
  final ApiClient _client;

  CategoryRepository(this._client);

  /// Fetches all categories/tags.
  Future<List<CategoryItem>> getCategories() async {
    final json = await _client.get(ApiConstants.categories);
    final list = json as List<dynamic>;
    return list
        .map((e) => CategoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
