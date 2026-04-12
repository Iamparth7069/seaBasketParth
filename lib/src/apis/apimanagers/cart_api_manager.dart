import 'package:seabasket/src/apis/api_route_constant.dart';
import 'package:seabasket/src/apis/api_service.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/models/request/req_cart_model.dart';
import 'package:seabasket/src/models/request/req_update_cart_model.dart';
import 'package:seabasket/src/models/response/res_cart_model.dart';
import 'package:seabasket/src/models/response/res_update_cart_model.dart';

class CartApiManager {
  Future<ResCartModel?> addToCart(ReqCartModel item) async {
    final response =
        await locator<ApiService>().post(apiAddCart, data: item.toJson());
    return ResCartModel.fromJson(response!.data);
  }

  Future<ResUpdateCartModel?> updateCartApiCall(
      ReqUpdateCartModel? item) async {
    final response = await locator<ApiService>()
        .patch(apiUpdateCart, params: item?.toJson());
    return ResUpdateCartModel.fromJson(response!.data);
  }
}
