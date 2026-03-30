import 'package:seabasket/src/apis/apimanagers/order_status_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/models/response/res_order_status_model.dart';

class OrderStatusController {
  Future<ResOrderStatusWrapper?> getOrderStatus(String orderId) async {
    return await locator<OrderStatusApiManager>().getOrderStatusApiCall(orderId);
  }

  Future<bool> submitReview(int rating) async {
    return await locator<OrderStatusApiManager>().submitReviewApiCall(rating);
  }
}
