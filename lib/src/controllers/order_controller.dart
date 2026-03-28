import 'package:seabasket/src/apis/apimanagers/order_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/models/order.dart';

class OrderController {
  Future<bool> saveOrders(List<Order> orders) async {
    return await locator<OrderApiManager>().saveOrdersApiCall(orders);
  }

  Future<List<Order>> getOrders() async {
    return await locator<OrderApiManager>().getOrdersApiCall();
  }

  Future<void> clearOrders() async {
    await locator<OrderApiManager>().clearOrdersApiCall();
  }
}
