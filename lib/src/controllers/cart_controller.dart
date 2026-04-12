import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/apis/apimanagers/cart_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/enum_utils.dart';
import 'package:seabasket/src/models/cart/cart_data_model.dart';
import 'package:seabasket/src/models/cart/cart_model.dart';
import 'package:seabasket/src/models/product/product_model.dart';
import 'package:seabasket/src/models/request/req_cart_model.dart';
import 'package:seabasket/src/models/request/req_update_cart_model.dart';
import 'package:seabasket/src/providers/cart_provider.dart';
import 'package:seabasket/src/providers/product_provider.dart';
import '../base/utils/progress_dialog_utils.dart';

class CartController {
  Future<CartModel?> addToCart(ReqCartModel item) async {
    ProgressDialogUtils.showProgressDialog();
    final response = await locator<CartApiManager>().addToCart(item);
    ProgressDialogUtils.dismissProgressDialog();
    return response!.data;
  }

  Future<bool> addProductToCart({
    required BuildContext context,
    required ProductModel product,
    required String? size,
  }) async {
    final productProvider = context.read<ProductProvider>();
    final cartProvider = context.read<CartProvider>();

    if (productProvider.isAddingToCart) return false;

    productProvider.setAddingToCart(true);

    final result = await addToCart(
      ReqCartModel(
        productId: product.id!,
        size: size ?? "",
        quantity: 1,
      ),
    );

    if (result != null) {
      cartProvider.addItem(
        CartModel(
          productId: result.productId ?? product.id,
          size: result.size ?? size,
          quantity: result.quantity ?? 1,
          cartItemId: result.cartItemId,
          productName: product.name,
          effectivePrice: product.discountedPrice ?? product.price ?? 0.0,
          image: product.imageUrl,
        ),
      );

      productProvider.setAddingToCart(false);
      return true;
    }

    productProvider.setAddingToCart(false);
    return false;
  }

  Future<CartDataModel?> updateCartAndGetData({
    ReqUpdateCartModel? item,
    bool dismissProgress = true,
  }) async {
    final response = await locator<CartApiManager>().updateCartApiCall(item);
    if (dismissProgress) {
      ProgressDialogUtils.dismissProgressDialog();
    }

    return response!.data;
  }

  Future<void> loadCart(BuildContext context) async {
    final data = await updateCartAndGetData(dismissProgress: true);

    if (data != null) {
      context.read<CartProvider>().setCartItems(data);
    }
  }

  Future<CartDataModel?> removeFromCart(
      ReqUpdateCartModel request, bool dismissProgress) async {
    return updateCartAndGetData(
        item: request, dismissProgress: dismissProgress);
  }

  Future<void> removeItem({
    required BuildContext context,
    required int index,
    required int? cartItemId,
  }) async {
    if (cartItemId == null) return;

    final provider = context.read<CartProvider>();

    provider.removeItem(index);

    final data = await removeFromCart(
      ReqUpdateCartModel(
        cartItemId: cartItemId,
        action: CartActionType.remove,
      ),
      true,
    );

    if (data != null) {
      provider.setCartItems(data);
    }
  }

  Future<void> updateQuantity({
    required BuildContext context,
    required int index,
    required CartActionType action,
  }) async {
    final cartProvider = context.read<CartProvider>();
    final item = cartProvider.cartItems[index];
    final cartItemId = item.cartItemId;
    final qty = item.quantity ?? 1;
    final newQty = action == CartActionType.increase ? qty + 1 : qty - 1;
    if (item.cartItemId == null) return;

    if (action == CartActionType.decrease && qty <= 1) {
      return;
    }

    cartProvider.updateItemQuantity(index, newQty);
    final data = await updateCartAndGetData(
      item: ReqUpdateCartModel(
        cartItemId: cartItemId,
        action: action,
      ),
      dismissProgress: false,
    );

    if (data != null) cartProvider.setCartItems(data);
  }
}
