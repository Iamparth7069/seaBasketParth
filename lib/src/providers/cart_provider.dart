import 'package:flutter/material.dart';
import 'package:seabasket/src/models/cart/cart_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> _cartItems = [];

  List<CartModel> get cartItems => _cartItems;

  final double shippingFee = 80.0;

  void setCartItems(List<CartModel> items) {
    _cartItems = items;
    notifyListeners();
  }

  void addItem(CartModel item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void updateItemQuantity(int index, int newQuantity) {
    _cartItems[index].quantity = newQuantity;
    notifyListeners();
  }

  void clearCart() {
    _cartItems = [];
    notifyListeners();
  }

  bool isInCart(int? productId, String? size) {
    return _cartItems.any(
      (item) => item.productId == productId && item.size == size,
    );
  }

  double get subtotal => _cartItems.fold(
        0,
        (sum, item) => sum + (item.effectivePrice ?? 0) * (item.quantity ?? 0),
      );

  double get total => subtotal + shippingFee;
}
