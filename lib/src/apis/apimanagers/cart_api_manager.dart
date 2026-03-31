import 'package:dio/dio.dart';
import 'package:seabasket/src/apis/api_route_constant.dart';
import 'package:seabasket/src/apis/api_service.dart';
import 'package:seabasket/src/apis/apimanagers/auth_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/models/cart_item.dart';
import 'package:seabasket/src/models/request/req_cart_model.dart';
import 'package:seabasket/src/models/request/req_update_cart_model.dart';
import 'package:seabasket/src/models/response/res_cart_model.dart';
import 'package:seabasket/src/models/response/res_update_cart_model.dart';

class CartApiManager {
  Future<ResCartModel?> addToCart(ReqCartModel item) async {
    final response =
        await locator<ApiService>().post(apiAddCart, data: item.toJson());

    if (response != null) {
      return ResCartModel.fromJson(response.data);
    }
    return null;
  }

  Future<ResUpdateCartModel?> updateCartApiCall(
      ReqUpdateCartModel? item) async {
    final response = await locator<ApiService>().patch(apiUpdateCart,
        params: item != null
            ? {"cart_item_id": item.cartItemId, "value": item.value}
            : {});

    if (response != null) {
      return ResUpdateCartModel.fromJson(response.data);
    }
    return null;
  }

  Future<ResCartModel?> getCartItemPatch(int cartItemId) async {
    final response = await locator<ApiService>()
        .patch(apiUpdateCart, params: {"cart_item_id": cartItemId});

    if (response != null) {
      return ResCartModel.fromJson(response.data);
    }
    return null;
  }
}
