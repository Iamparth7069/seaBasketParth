import 'package:seabasket/src/base/utils/enum_utils.dart';

class OrderStatusApiManager {
  Future<OrderStatus> getOrderStatusApiCall() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return OrderStatus.delivered;
  }

  Future<bool> submitReviewApiCall(int rating) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
