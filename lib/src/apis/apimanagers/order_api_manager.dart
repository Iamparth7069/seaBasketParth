import 'package:seabasket/src/apis/api_route_constant.dart';
import 'package:seabasket/src/apis/api_service.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/models/request/req_add_rating_model.dart';
import 'package:seabasket/src/models/request/req_my_orders_model.dart';
import 'package:seabasket/src/models/response/res_add_rating_model.dart';
import 'package:seabasket/src/models/response/res_my_order_model.dart';

class OrderApiManager {
  Future<List<ResMyOrderModel>?> getMyOrdersApiCall(
      ReqMyOrdersModel request) async {
    final response = await locator<ApiService>().get(
      apiGetMyOrders,
      params: request.toJson(),
    );
    return ResMyOrderModel.listFromData(response!.data);
  }

  Future<void> addRating(ReqAddRatingModel request) async {
    final response = await locator<ApiService>().post(
      apiPostRating,
      data: request.toJson(),
    );
    return response!.data;
  }
}
