import 'package:seabasket/src/apis/apimanagers/category_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/models/category/category_model.dart';

class CategoryController {
  Future<List<CategoryModel>?> getAllCategories() async {
    return await locator<CategoryApiManager>().getAllCategories();
  }
}
