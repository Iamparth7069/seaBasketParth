import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:seabasket/src/apis/api_route_constant.dart';
import 'package:seabasket/src/apis/api_service.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/constants/image_constant.dart';
import 'package:seabasket/src/models/category/category_model.dart';
import 'package:seabasket/src/models/product.dart';
import 'package:seabasket/src/models/product/product_model.dart';
import 'package:seabasket/src/models/response/res_product_detail_model.dart';

class ProductApiManager {
  Future<List<ProductModel>?> getProductsApiCall({
    String? name,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sort,
  }) async {
    final response = await locator<ApiService>().get(
      apiAllProducts,
      params: {
        if (categoryId != null) "category_id": categoryId,
        if (name != null) "name": name,
        if (minPrice != null) "min_price": minPrice,
        if (maxPrice != null && maxPrice < 2000) "max_price": maxPrice,
        if (minRating != null) "min_rating": minRating,
        if (sort != null) "sort": sort,
      },
    );
    if (response == null) return null;
    final list = response.data as List;
    return list
        .map(
          (product) => ProductModel.fromJson(product),
        )
        .toList();
  }

  Future<ResProductDetailModel?> getProductByIdApiCall(int productId) async {
    final response = await locator<ApiService>().get(
      '$apiGetProduct/$productId',
    );
    if (response == null) return null;

    return ResProductDetailModel.fromJson(response.data);
  }
}
