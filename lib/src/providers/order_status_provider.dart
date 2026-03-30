import 'package:flutter/material.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/enum_utils.dart';
import 'package:seabasket/src/controllers/order_status_controller.dart';

class OrderStatusProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  OrderStatus _currentStatus = OrderStatus.packing;
  OrderStatus get currentStatus => _currentStatus;

  int _selectedRating = 0;
  int get selectedRating => _selectedRating;

  bool get isDelivered => _currentStatus == OrderStatus.delivered;

  Future<void> loadOrderStatus(String orderId) async {
    _setLoading(true);
    final response = await locator<OrderStatusController>().getOrderStatus(orderId);
    if (response != null && response.data != null && response.data!.orderStatus != null) {
      final statusStr = response.data!.orderStatus!;
      _currentStatus = OrderStatus.values.firstWhere(
        (e) {
          final val = e.name.toLowerCase();
          final passed = statusStr.toLowerCase();
          return val == passed || (val == 'delivered' && passed == 'deliverd');
        }, 
        orElse: () => OrderStatus.packing);
    }
    _setLoading(false);
  }

  void selectRating(int rating) {
    _selectedRating = rating;
    notifyListeners();
  }

  Future<bool> submitReview() async {
    _isSubmitting = true;
    notifyListeners();
    final success =
        await locator<OrderStatusController>().submitReview(_selectedRating);
    _isSubmitting = false;
    notifyListeners();
    return success;
  }

  void reset() {
    _selectedRating = 0;
    _currentStatus = OrderStatus.packing;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setStatusFromString(String statusStr) {
    _currentStatus = OrderStatus.values.firstWhere(
        (e) {
          final val = e.name.toLowerCase();
          final passed = statusStr.toLowerCase();
          return val == passed || (val == 'delivered' && passed == 'deliverd');
        }, 
        orElse: () => OrderStatus.packing);
    notifyListeners();
  }
}
