import 'package:seabasket/src/apis/api_service.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/enum_utils.dart';
import 'package:seabasket/src/models/response/res_order_status_model.dart';

class OrderStatusApiManager {
  Future<ResOrderStatusWrapper?> getOrderStatusApiCall(String orderId) async {
    final response = await locator<ApiService>().get("orders/$orderId/status");
    if (response != null && response.data != null) {
      if (response.data is Map<String, dynamic>) {
        return ResOrderStatusWrapper.fromJson(response.data);
      }
    }
    return null;
  }

  Future<bool> submitReviewApiCall(int rating) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
