import 'package:flutter/material.dart';

import 'package:seabasket/src/models/response/res_my_order_model.dart';

class OrderProvider extends ChangeNotifier {
  List<ResMyOrderModel> _myOrders = [];
  List<ResMyOrderModel> get myOrders => _myOrders;

  void setMyOrders(List<ResMyOrderModel> orders) {
    _myOrders = orders;
    notifyListeners();
  }

  void clearOrders() {
    _myOrders = [];
    notifyListeners();
  }
}