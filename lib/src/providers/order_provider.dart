import 'package:flutter/material.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/controllers/order_controller.dart';
import 'package:seabasket/src/models/cart_item.dart';
import 'package:seabasket/src/models/order.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  List<Order> get orders => _orders;

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
    _isLoading = true;
    _orders = await locator<OrderController>().getOrders();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> saveOrderesFromCart(
      List<CartItem> cartItems, double total, double shippingFee) async {
    _isLoading = true;
    final orderId = DateTime.now().microsecond.toString();
    // final orders = cartItems
    //     .map((item) => Order(
    //           orderId: orderId,
    //           productId: item.id,
    //           name: item.name,
    //           size: item.size,
    //           price: item.price,
    //           quantity: item.quantity,
    //           image: item.image,
    //           totalAmount: total,
    //           shippingFee: shippingFee,
    //         ))
    //     .toList();

    final success = await locator<OrderController>().saveOrders(orders);
    if (success) await loadOrders();
    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> clearOrders() async {
    await locator<OrderController>().clearOrders();
    _orders = [];
    notifyListeners();
  }
}
