import 'package:seabasket/src/apis/apimanagers/auth_api_manager.dart';
import 'package:seabasket/src/apis/apimanagers/cart_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/models/cart/cart_data_model.dart';
import 'package:seabasket/src/models/cart/cart_model.dart';
import 'package:seabasket/src/models/cart_item.dart';
import 'package:seabasket/src/models/request/req_cart_model.dart';
import 'package:seabasket/src/models/request/req_update_cart_model.dart';
import 'package:seabasket/src/models/response/res_cart_model.dart';

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

  Future<CartModel?> getCartItemPatch(int cartItemId) async {
    ProgressDialogUtils.showProgressDialog();
    final response = await locator<CartApiManager>().getCartItemPatch(cartItemId);
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
    print("modify Values is ${modify}");

    if (modify) {
      ProgressDialogUtils.showProgressDialog();
    }

    final response = await locator<CartApiManager>()
        .updateCartApiCall(item);

    if (modify) {
      ProgressDialogUtils.dismissProgressDialog();
    }

    if (response == null) return null;
    return response.data;
  }
  Future<CartDataModel?> removeFromCart(int id,bool? modify) async {
    return await getCartData(
      item: ReqUpdateCartModel(
        cartItemId: id,
        value: "remove",
      ),
      modify: modify!
    );
  }
}
