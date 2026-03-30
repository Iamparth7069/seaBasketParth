import 'package:flutter/material.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/controllers/order_controller.dart';
import 'package:seabasket/src/models/cart_item.dart';
import 'package:seabasket/src/models/order.dart';
import 'package:seabasket/src/models/response/res_my_order_model.dart';

import '../base/utils/progress_dialog_utils.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  List<Order> get orders => _orders;

  List<ResMyOrderModel> _myOrders = [];
  List<ResMyOrderModel> get myOrders => _myOrders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, List<Order>> get groupedOrders {
    final Map<String, List<Order>> grouped = {};
    for (var order in _orders) {
      grouped[order.orderId] ??= [];
      grouped[order.orderId]!.add(order);
    }
    return grouped;
  }

  Future<void> loadOrders() async {
    _orders = await locator<OrderController>().getOrders();
    _isLoading = false;
    notifyListeners();
  }

  void setLoading(bool value) {
    if(value){
      ProgressDialogUtils.showProgressDialog();
    }else{
      ProgressDialogUtils.dismissProgressDialog();
    }
    notifyListeners();
  }

  void setMyOrders(List<ResMyOrderModel> newOrders) {
    _myOrders = newOrders;
    notifyListeners();
  }


  Future<void> clearOrders() async {
    await locator<OrderController>().clearOrders();
    _orders = [];
    notifyListeners();
  }
}
