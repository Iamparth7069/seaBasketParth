import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/apis/apimanagers/product_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/enum_utils.dart';
import 'package:seabasket/src/models/product/product_model.dart';
import 'package:seabasket/src/models/response/res_product_detail_model.dart';
import 'package:seabasket/src/providers/bottom_nav_provider.dart';
import 'package:seabasket/src/providers/product_provider.dart';
import '../base/utils/progress_dialog_utils.dart';

class ProductController {
  double? _getMinDiscount(Set<int> discounts) {
    if (discounts.isEmpty) return null;

    return discounts.reduce((a, b) => a < b ? a : b).toDouble();
  }

  Future<List<ProductModel>?> getProducts({
    required ProductProvider provider,
    bool loadMore = false,
    int? categoryId,
    String? name,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    Set<int>? discounts,
    ProductSortType? sort,
  }) async {
    if (provider.isLoading) return [];
    provider.setLoading(true);
    if (!loadMore) {
      provider.resetPage();
      provider.clearProducts();
    }

    final minDiscount = _getMinDiscount(discounts ?? {});
    final result = await locator<ProductApiManager>().getProductsApiCall(
      page: provider.page,
      pageSize: provider.pageSize,
      categoryId: (categoryId != null && categoryId != 0) ? categoryId : null,
      name: (name != null && name.trim().isNotEmpty) ? name.trim() : null,
      minPrice: (minPrice != null && minPrice > 0) ? minPrice : null,
      maxPrice: (maxPrice != null && maxPrice < 2000) ? maxPrice : null,
      discount: minDiscount,
      minRating: (minRating != null && minRating > 0) ? minRating : null,
      sort: sort?.displayValue,
    );

    if (result != null && result.isNotEmpty) {
      provider.setProducts(
        result,
        append: loadMore,
      );

      if (result.length < provider.pageSize) {
        provider.updateHasMore(false);
      } else {
        provider.incrementPage();
      }
    } else {
      provider.updateHasMore(false);
    }
    provider.setLoading(false);
    return result ?? [];
  }

  Future<ResProductDetailModel?> getProductById(
      BuildContext context, int productId) async {
    ProgressDialogUtils.showProgressDialog();
    final response =
        await locator<ProductApiManager>().getProductByIdApiCall(productId);
    ProgressDialogUtils.dismissProgressDialog();
    if (response != null) {
      context.read<ProductProvider>().setSelectedProduct(response);
    }
    return response;
  }

  void onSizeSelected(BuildContext context, int index) {
    context.read<ProductProvider>().selectSize(index);
  }

  void openFilters(ProductProvider provider) {
    provider.openFilterSheet();
  }

  void applyFilterAndRefresh(ProductProvider provider) {
    provider.resetPage();
    provider.clearProducts();
  }

  Future<void> searchProducts({
    required ProductProvider provider,
    required String query,
  }) async {
    provider.setSearchQuery(query);

    await getProducts(
      provider: provider,
      name: query.trim(),
      loadMore: false,
    );
  }

  void goToCart(BuildContext context) {
    context.read<BottomNavProvider>().changeTab(2);
  }

  void onSortSelected(BuildContext context, int index) {
    context.read<ProductProvider>().selectSort(index);
  }

  void onPriceChanged(BuildContext context, RangeValues value) {
    context.read<ProductProvider>().updatePriceRange(value);
  }

  void onRatingSelected(BuildContext context, double? rating) {
    context.read<ProductProvider>().selectRating(rating);
  }

  void onDiscountToggle(BuildContext context, int discount) {
    context.read<ProductProvider>().toggleDiscount(discount);
  }

  void applyFilters(BuildContext context) {
    final provider = context.read<ProductProvider>();
    provider.applyFilters();
    provider.resetPage();
    provider.clearProducts();
  }

  void clearFilters(BuildContext context) {
    context.read<ProductProvider>().clearFilters();
  }
}
