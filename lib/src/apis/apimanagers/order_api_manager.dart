import 'package:seabasket/src/apis/api_route_constant.dart';
import 'package:seabasket/src/apis/api_service.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/models/request/req_add_rating_model.dart';
import 'package:seabasket/src/models/response/res_my_order_model.dart';

class OrderApiManager {
  Future<List<ResMyOrderModel>?> getMyOrdersApiCall(int? orderId) async {
    final response = await locator<ApiService>().get(apiGetMyOrders,
        params: orderId != null ? {'order_id': orderId.toString()} : null);

    if (response != null && response.data != null) {
      final data = response.data['data'];
      if (data is List) {
        return data
            .map((e) => ResMyOrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      if (data is Map<String, dynamic>) {
        return [ResMyOrderModel.fromJson(data)];
      }
    }
    return null;
  }

  Future<bool> addRating(ReqAddRatingModel request) async {
    final response = await locator<ApiService>().post(
      apiPostRating,
      data: request.toJson(),
    );
    return response != null;
  }
}
