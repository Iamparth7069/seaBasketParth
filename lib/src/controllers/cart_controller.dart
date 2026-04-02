import 'package:seabasket/src/apis/apimanagers/cart_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/models/cart/cart_data_model.dart';
import 'package:seabasket/src/models/cart/cart_model.dart';
import 'package:seabasket/src/models/request/req_cart_model.dart';
import 'package:seabasket/src/models/request/req_update_cart_model.dart';
import 'package:seabasket/src/providers/cart_provider.dart';
import '../base/utils/progress_dialog_utils.dart';

class CartController {
  Future<CartModel?> addToCart(ReqCartModel item) async {
    ProgressDialogUtils.showProgressDialog();
    final response = await locator<CartApiManager>().addToCart(item);
    ProgressDialogUtils.dismissProgressDialog();

    if (response == null) {
      return null;
    }

    return response.data;
  }

  Future<CartDataModel?> getCartData({
    ReqUpdateCartModel? item,
    bool modify = true,
  }) async {
    final response = await locator<CartApiManager>().updateCartApiCall(item);
    if (modify) {
      ProgressDialogUtils.dismissProgressDialog();
    }
    if (response == null) return null;
    return response.data;
  }

  Future<CartDataModel?> removeFromCart(int id, bool? modify) async {
    return await getCartData(
        item: ReqUpdateCartModel(
          cartItemId: id,
          value: "remove",
        ),
        modify: modify!);
  }

  Future<void> updateQuantity({
    required CartProvider cartProvider,
    required int index,
    required String value,
  }) async {
    final item = cartProvider.cartItems[index];
    if (item.cartItemId == null) return;

    if (value == "decrease" && (item.quantity ?? 1) <= 1) {
      cartProvider.removeItem(index);
      final data = await removeFromCart(item.cartItemId!, true);
      if (data != null) cartProvider.setCartItems(data);
      return;
    }

    cartProvider.updateItemQuantity(
      index,
      value == "increase" ? (item.quantity ?? 0) + 1 : (item.quantity ?? 1) - 1,
    );

    final data = await getCartData(
      item: ReqUpdateCartModel(
        cartItemId: item.cartItemId,
        value: value,
      ),
      modify: false,
    );

    if (data != null) cartProvider.setCartItems(data);
  }
}
