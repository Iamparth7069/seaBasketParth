import 'package:seabasket/src/apis/apimanagers/order_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/models/order.dart';
import 'package:seabasket/src/models/response/res_my_order_model.dart';

class OrderController {

  Future<List<Order>> getOrders() async {
    return await locator<OrderApiManager>().getOrdersApiCall();
  }

  Future<void> clearOrders() async {
    await locator<OrderApiManager>().clearOrdersApiCall();
  }

  Future<List<ResMyOrderModel>?> getMyOrders() async {
    return await locator<OrderApiManager>().getMyOrdersApiCall();
  }
}
