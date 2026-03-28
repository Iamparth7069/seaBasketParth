import 'package:flutter/material.dart';
import 'package:seabasket/src/apis/apimanagers/product_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/string_extension.dart';
import 'package:seabasket/src/base/utils/enum_utils.dart';
import 'package:seabasket/src/models/category/category_model.dart';
import 'package:seabasket/src/models/product.dart';
import 'package:seabasket/src/models/product/product_model.dart';
import 'package:seabasket/src/models/response/res_product_detail_model.dart';
import '../base/utils/progress_dialog_utils.dart';

class ProductController {
  Future<List<ProductModel>?> getProducts({
    int? categoryId,
    String? name,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    ProductSortType? sort,
  }) async {
    return await locator<ProductApiManager>().getProductsApiCall(
      categoryId: (categoryId != null && categoryId != 0) ? categoryId : null,
      name: (name != null && name.trim().isNotEmpty) ? name.trim() : null,
      minPrice: (minPrice != null && minPrice > 0) ? minPrice : null,
      maxPrice: (maxPrice != null && maxPrice < 2000) ? maxPrice : null,
      minRating: (minRating != null && minRating > 0) ? minRating : null,
      sort: sort?.displayValue,
    );
  }

  Future<ResProductDetailModel?> getProductById(int productId) async {
    ProgressDialogUtils.showProgressDialog();
    final response =
        await locator<ProductApiManager>().getProductByIdApiCall(productId);
    ProgressDialogUtils.dismissProgressDialog();
    return response;
  }
}
