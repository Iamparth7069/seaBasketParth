import 'package:flutter/material.dart';
import 'package:seabasket/src/models/cart/cart_data_model.dart';
import 'package:seabasket/src/models/cart/cart_model.dart';
import 'package:seabasket/src/models/cart/cart_summary_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> _cartItems = [];
  CartSummaryModel? _summary;
  List<CartModel> get cartItems => _cartItems;

  double get subtotal => _summary?.subtotal ?? 0;
  double get shippingFee => _summary?.shipping ?? 0;
  double get total => _summary?.grandTotal ?? 0;

  void setCartItems(CartDataModel data) {
    _cartItems = data.items;
    _summary = data.summary;
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
}
