import 'dart:convert';

import 'package:seabasket/src/apis/api_route_constant.dart';
import 'package:seabasket/src/apis/api_service.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/constants/preference_key_constant.dart';
import 'package:seabasket/src/base/utils/preference_utils.dart';
import 'package:seabasket/src/models/order.dart';
import 'package:seabasket/src/models/response/res_my_order_model.dart';

class OrderApiManager {

  Future<List<Order>> getOrdersApiCall() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final String ordersJson = getString(prefkeyOrders, "");
    if (ordersJson.isEmpty) return [];

    final List<dynamic> decoded = jsonDecode(ordersJson);
    return decoded
        .map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> clearOrdersApiCall() async {
    await Future.delayed(const Duration(milliseconds: 300));
    setString(prefkeyOrders, "");
  }

  Future<List<ResMyOrderModel>?> getMyOrdersApiCall() async {
    final response = await locator<ApiService>().get(apiGetMyOrders);
    if (response != null && response.data != null) {
      if (response.data is Map<String, dynamic> && response.data['data'] is List) {
        final List<dynamic> dataList = response.data['data'];
        return dataList.map((e) => ResMyOrderModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    }
    return null;
  }
}
