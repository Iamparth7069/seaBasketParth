import 'package:seabasket/src/apis/apimanagers/product_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/enum_utils.dart';
import 'package:seabasket/src/models/product/product_model.dart';
import 'package:seabasket/src/models/response/res_product_detail_model.dart';
import '../base/utils/progress_dialog_utils.dart';

class ProductController {
  int _page = 1;
  int _pageSize = 10;
  bool _hasMore = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  void resetPage() {
    _page = 1;
    _hasMore = true;
  }

  double? _getMinDiscount(Set<int> discounts) {
    if (discounts.isEmpty) return null;

    return discounts.reduce((a, b) => a < b ? a : b).toDouble();
  }

  Future<List<ProductModel>?> getProducts({
    bool loadMore = false,
    int? categoryId,
    String? name,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    Set<int>? discounts,
    ProductSortType? sort,
  }) async {
    if (_isLoading || !_hasMore) return [];
    _isLoading = true;

    if (!loadMore) {
      resetPage();
    }

    final minDiscount = _getMinDiscount(discounts ?? {});
    final result = await locator<ProductApiManager>().getProductsApiCall(
      page: _page,
      pageSize: _pageSize,
      categoryId: (categoryId != null && categoryId != 0) ? categoryId : null,
      name: (name != null && name.trim().isNotEmpty) ? name : null,
      minPrice: (minPrice != null && minPrice > 0) ? minPrice : null,
      maxPrice: (maxPrice != null && maxPrice < 2000) ? maxPrice : null,
      discount: minDiscount,
      minRating: (minRating != null && minRating > 0) ? minRating : null,
      sort: sort?.displayValue,
    );
    if (result != null && result.isNotEmpty) {
      if (result.length < _pageSize) {
        _hasMore = false;
      } else {
        _page++;
      }
    } else {
      _hasMore = false;
    }
    _isLoading = false;
    return result ?? [];
  }

  Future<ResProductDetailModel?> getProductById(int productId) async {
    ProgressDialogUtils.showProgressDialog();
    final response =
        await locator<ProductApiManager>().getProductByIdApiCall(productId);
    ProgressDialogUtils.dismissProgressDialog();
    return response;
  }
}
