import 'dart:convert';

import 'package:seabasket/src/apis/api_route_constant.dart';
import 'package:seabasket/src/apis/api_service.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/constants/preference_key_constant.dart';
import 'package:seabasket/src/base/utils/preference_utils.dart';
import 'package:seabasket/src/models/order.dart';
import 'package:seabasket/src/models/response/res_my_order_model.dart';

class OrderApiManager {
  Future<List<ResMyOrderModel>?> getMyOrdersApiCall(int? orderId) async {
    final response = await locator<ApiService>().get(apiGetMyOrders,
        params: orderId != null ? {'order_id': orderId.toString()} : null);

    if (response != null && response.data != null) {
      if (response.data is Map<String, dynamic> &&
          response.data['data'] is List) {
        final List<dynamic> dataList = response.data['data'];
        return dataList
            .map((e) => ResMyOrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return null;
  }
}