import 'package:seabasket/src/apis/apimanagers/order_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/progress_dialog_utils.dart';
import 'package:seabasket/src/models/order.dart';
import 'package:seabasket/src/models/response/order_item_model.dart';
import 'package:seabasket/src/models/response/res_my_order_model.dart';

class OrderController {
  Future<List<ResMyOrderModel>> getMyOrders({int? orderId}) async {
    ProgressDialogUtils.showProgressDialog();

    final orders = await locator<OrderApiManager>().getMyOrdersApiCall(orderId);

    ProgressDialogUtils.dismissProgressDialog();

    return orders ?? [];
  }
}