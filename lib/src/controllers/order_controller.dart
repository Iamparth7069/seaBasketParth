import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/apis/apimanagers/order_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/progress_dialog_utils.dart';
import 'package:seabasket/src/models/request/req_add_rating_model.dart';
import 'package:seabasket/src/models/request/req_my_orders_model.dart';
import 'package:seabasket/src/models/response/res_add_rating_model.dart';
import 'package:seabasket/src/models/response/res_my_order_model.dart';
import 'package:seabasket/src/providers/order_provider.dart';

class OrderController {
  Future<List<ResMyOrderModel>> getMyOrders(
    BuildContext context,
    ReqMyOrdersModel request,
  ) async {
    ProgressDialogUtils.showProgressDialog();
    final orders = await locator<OrderApiManager>().getMyOrdersApiCall(request);
    if (orders != null) {
      context.read<OrderProvider>().setMyOrders(orders);
    }
    ProgressDialogUtils.dismissProgressDialog();

    return orders ?? [];
  }

  Future<void> addReview(ReqAddRatingModel request) async {
    return await locator<OrderApiManager>().addRating(request);
  }

  Future<void> submitRating({
    required BuildContext context,
    required int productId,
    required int rating,
  }) async {
    final provider = context.read<OrderProvider>();

    provider.setRated(productId, true);
    provider.setRating(productId, rating);

    final req = ReqAddRatingModel(
      productId: productId,
      comment: "",
      rating: rating,
    );

    await addReview(req);

    provider.setRating(productId, 0);
    provider.setRated(productId, false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(Localization.of().ratingFailedMessage),
      ),
    );
  }
}
