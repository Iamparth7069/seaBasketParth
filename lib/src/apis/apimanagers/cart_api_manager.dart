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
  final List<CartItem> _cartItems = [];

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
        data: item != null
            ? {"cart_item_id": item.cartItemId, "value": item.value}
            : {});

    if (response != null) {
      return ResUpdateCartModel.fromJson(response.data);
    }
  }

  // Future<List<CartItem>> getCartItems() async {
  //   await Future.delayed(const Duration(milliseconds: 300));
  //   return _cartItems;
  // }

  // Future<void> addToCart(CartItem item) async {
  //   await Future.delayed(const Duration(milliseconds: 200));

  //   final existingIndex = _cartItems.indexWhere(
  //     (cartItem) => cartItem.id == item.id && cartItem.size == item.size,
  //   );

  //   if (existingIndex != -1) {
  //     _cartItems[existingIndex].quantity =
  //         (_cartItems[existingIndex].quantity ?? 1) + (item.quantity ?? 1);
  //   } else {
  //     _cartItems.add(item);
  //   }
  // }

  Future<void> removeFromCart(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cartItems.removeWhere((item) => item.id == id);
  }

  Future<void> updateQuantity(int id, int quantity) async {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _cartItems[index].quantity = quantity;
    }
  }

  Future<void> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cartItems.clear();
    print("CartApiManager: cleared → ${_cartItems.length}");
  }
}
