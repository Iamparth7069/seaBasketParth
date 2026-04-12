import 'package:seabasket/src/apis/apimanagers/category_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/models/category/category_model.dart';
import 'package:seabasket/src/providers/category_provider.dart';
import 'package:seabasket/src/providers/product_provider.dart';

class CategoryController {
  Future<List<CategoryModel>?> getAllCategories() async {
    return await locator<CategoryApiManager>().getAllCategories();
  }

  void onCategorySelected({
    required CategoryProvider categoryProvider,
    required ProductProvider productProvider,
    required int index,
    required int? categoryId,
  }) {
    categoryProvider.selectCategory(index);
    productProvider.setSelectedCategory(categoryId);

    productProvider.resetPage();
    productProvider.clearProducts();
    productProvider.updateHasMore(true);
  }
}
