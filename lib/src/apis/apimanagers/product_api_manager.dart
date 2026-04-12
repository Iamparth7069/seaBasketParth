import 'package:seabasket/src/apis/api_route_constant.dart';
import 'package:seabasket/src/apis/api_service.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/models/product/product_model.dart';
import 'package:seabasket/src/models/response/res_product_detail_model.dart';

class ProductApiManager {
  Future<List<ProductModel>?> getProductsApiCall({
    int? page,
    int? pageSize,
    String? name,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    double? discount,
    String? sort,
  }) async {
    final response = await locator<ApiService>().get(
      apiAllProducts,
      params: {
        if (page != null) "page": page,
        if (pageSize != null) "page_size": pageSize,
        if (categoryId != null) "category_id": categoryId,
        if (name != null) "name": name,
        if (minPrice != null) "min_price": minPrice,
        if (maxPrice != null) "max_price": maxPrice,
        if (discount != null) "min_discount": discount,
        if (minRating != null) "min_rating": minRating,
        if (sort != null) "sort": sort,
      },
    );

    final list = response!.data as List;
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

    return ResProductDetailModel.fromJson(response!.data);
  }
}
