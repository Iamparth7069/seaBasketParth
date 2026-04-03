import 'package:flutter/material.dart';
import 'package:seabasket/src/models/cart/cart_model.dart';

class CheckoutProvider extends ChangeNotifier {
  bool _isEditing = false;
  bool get isEditing => _isEditing;

  CartModel? _buyNowItem;
  CartModel? get buyNowItem => _buyNowItem;

  double get buyNowSubtotal =>
      (_buyNowItem?.effectivePrice ?? 0) * (_buyNowItem?.quantity ?? 1);

  final double shippingFee = 80.0;

  double get buyNowTotal => buyNowSubtotal + shippingFee;

  void setEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  void toggleEditing() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  /// Call this when entering the checkout screen to ensure the button
  /// always starts showing "Change" (not "Save") on fresh entry.
  void resetEditing() {
    _isEditing = false;
    notifyListeners();
  }
}
