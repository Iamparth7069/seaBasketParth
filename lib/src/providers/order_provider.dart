import 'package:flutter/material.dart';

import 'package:seabasket/src/models/response/res_my_order_model.dart';

class OrderProvider extends ChangeNotifier {
  List<ResMyOrderModel> _myOrders = [];
  List<ResMyOrderModel> get myOrders => _myOrders;

  List<ResMyOrderModel> _historyOrders = [];
  List<ResMyOrderModel> get historyOrders => _historyOrders;

  final Map<int, int> _ratings = {};
  final Set<int> _clickedProducts = {};

  void setMyOrders(List<ResMyOrderModel> orders) {
    _myOrders = orders;
    notifyListeners();
  }

  void setOrderHistory(List<ResMyOrderModel> orders) {
    _historyOrders = orders;
    notifyListeners();
  }

  int getRating(int productId) {
    return _ratings[productId] ?? 0;
  }

  void setRating(int productId, int rating) {
    _ratings[productId] = rating;
    notifyListeners();
  }

  bool isClicked(int productId) {
    return _clickedProducts.contains(productId);
  }

  void setClicked(int productId, bool value) {
    if (value) {
      _clickedProducts.add(productId);
    } else {
      _clickedProducts.remove(productId);
    }
    notifyListeners();
  }

  void clearOrders() {
    _myOrders = [];
    _historyOrders = [];
    notifyListeners();
  }
}
