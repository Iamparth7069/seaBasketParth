import 'package:seabasket/src/apis/apimanagers/order_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/progress_dialog_utils.dart';
import 'package:seabasket/src/models/request/req_add_rating_model.dart';
import 'package:seabasket/src/models/response/res_my_order_model.dart';

class OrderController {
  Future<List<ResMyOrderModel>> getMyOrders({int? orderId}) async {
    ProgressDialogUtils.showProgressDialog();

    final orders = await locator<OrderApiManager>().getMyOrdersApiCall(orderId);

    ProgressDialogUtils.dismissProgressDialog();

    return orders ?? [];
  }

  Future<bool> addReview(ReqAddRatingModel request) async {
    return await locator<OrderApiManager>().addRating(request);
  }
}
