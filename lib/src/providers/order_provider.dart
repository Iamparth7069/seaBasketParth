import 'package:flutter/material.dart';

import 'package:seabasket/src/models/response/res_my_order_model.dart';

class OrderProvider extends ChangeNotifier {
  List<ResMyOrderModel> _myOrders = [];
  List<ResMyOrderModel> get myOrders => _myOrders;

  List<ResMyOrderModel> _historyOrders = [];
  List<ResMyOrderModel> get historyOrders => _historyOrders;

  void setMyOrders(List<ResMyOrderModel> orders) {
    _myOrders = orders;
    notifyListeners();
  }

  void setOrderHistory(List<ResMyOrderModel> orders) {
    _historyOrders = orders;
    notifyListeners();
  }

  void clearOrders() {
    _myOrders = [];
    _historyOrders = [];
    notifyListeners();
  }
}
