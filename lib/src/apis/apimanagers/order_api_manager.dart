import 'dart:convert';

import 'package:seabasket/src/base/utils/constants/preference_key_constant.dart';
import 'package:seabasket/src/base/utils/preference_utils.dart';
import 'package:seabasket/src/models/order.dart';

class OrderApiManager {
  Future<bool> saveOrdersApiCall(List<Order> orders) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final existOrders = await getOrdersApiCall();
    existOrders.addAll(orders);
    final responseValue = jsonEncode(
      existOrders.map((order) => order.toJson()).toList(),
    );
    setString(prefkeyOrders, responseValue);
    return true;
  }

  Future<List<Order>> getOrdersApiCall() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final storedOrders = getString(prefkeyOrders);
    if (storedOrders.isEmpty) return [];
    final List<dynamic> responseData = jsonDecode(storedOrders);
    return responseData.map((order) => Order.fromJson(order)).toList();
  }

  Future<void> clearOrdersApiCall() async {
    await Future.delayed(const Duration(milliseconds: 200));
    setString(prefkeyOrders, "");
  }
}
