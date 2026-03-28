import 'package:seabasket/src/apis/apimanagers/order_status_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/enum_utils.dart';

class OrderStatusController {
  Future<OrderStatus> getOrderStatus() async {
    return await locator<OrderStatusApiManager>().getOrderStatusApiCall();
  }

  Future<bool> submitReview(int rating) async {
    return await locator<OrderStatusApiManager>().submitReviewApiCall(rating);
  }
}
