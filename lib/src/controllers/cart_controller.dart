import 'package:seabasket/src/apis/apimanagers/auth_api_manager.dart';
import 'package:seabasket/src/apis/apimanagers/cart_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/models/cart/cart_data_model.dart';
import 'package:seabasket/src/models/cart/cart_model.dart';
import 'package:seabasket/src/models/cart_item.dart';
import 'package:seabasket/src/models/request/req_cart_model.dart';
import 'package:seabasket/src/models/request/req_update_cart_model.dart';
import 'package:seabasket/src/models/response/res_cart_model.dart';

class CartController {
  Future<CartModel?> addToCart(ReqCartModel item) async {
    final response = await locator<CartApiManager>().addToCart(item);

    if (response == null) {
      return null;
    }

    return response.data;
  }

  Future<CartDataModel?> getCartData({ReqUpdateCartModel? item}) async {
    final respones = await locator<CartApiManager>().updateCartApiCall(item);
    if (respones == null) return null;
    return respones.data;
  }

  Future<void> removeFromCart(int id) async {
    await locator<CartApiManager>().removeFromCart(id);
  }

  Future<void> updateQuantity(int id, int quantity) async {
    await locator<CartApiManager>().updateQuantity(id, quantity);
  }

  double getSubtotal(List<CartItem> cartItems) {
    double sum = 0;
    for (var item in cartItems) {
      sum += (item.price ?? 0.0) * (item.quantity ?? 1);
    }
    return sum;
  }

  double getTotal(List<CartItem> cartItems, double shippingFee) {
    if (cartItems.isEmpty) return 0;
    return getSubtotal(cartItems) + shippingFee;
  }

  Future<void> clearCart() async {
    await locator<CartApiManager>().clearCart();
  }
}
