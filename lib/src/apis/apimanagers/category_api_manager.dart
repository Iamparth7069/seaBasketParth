import 'package:seabasket/src/apis/api_route_constant.dart';
import 'package:seabasket/src/apis/api_service.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/models/category/category_model.dart';

class CategoryApiManager {
  Future<List<CategoryModel>?> getAllCategories() async {
    final response = await locator<ApiService>().get(apiAllCategories);
    if (response == null) return null;
    final list = response.data['data'] as List;
    return list.map((category) => CategoryModel.fromJson(category)).toList();
  }
}
