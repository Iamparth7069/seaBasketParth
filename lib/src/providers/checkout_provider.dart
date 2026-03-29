import 'package:flutter/material.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/controllers/checkout_controller.dart';
import 'package:seabasket/src/models/cart/cart_model.dart';

class CheckoutProvider extends ChangeNotifier {
  // ── Loading ──────────────────────────────────────────────────────────────
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ── Address editing ───────────────────────────────────────────────────────
  bool _isEditing = false;
  bool get isEditing => _isEditing;

  // ── Payment card ─────────────────────────────────────────────────────────
  String _cardNumber = "";
  String get cardNumber => _cardNumber;

  String _expiryDate = "";
  String get expiryDate => _expiryDate;

  String _securityCode = "";
  String get securityCode => _securityCode;

  // ── Buy Now state ─────────────────────────────────────────────────────────
  /// True when the user arrived via "Buy Now" (single-item checkout).
  bool _isBuyNow = false;
  bool get isBuyNow => _isBuyNow;

  /// The single item selected via "Buy Now".
  CartModel? _buyNowItem;
  CartModel? get buyNowItem => _buyNowItem;

  /// Subtotal for the buy-now item (effectivePrice × quantity).
  double get buyNowSubtotal =>
      (_buyNowItem?.effectivePrice ?? 0) * (_buyNowItem?.quantity ?? 1);

  /// Fixed shipping fee (same as CartProvider).
  final double shippingFee = 80.0;

  /// Total for buy-now flow.
  double get buyNowTotal => buyNowSubtotal + shippingFee;

  /// Set the item for a "Buy Now" checkout and switch to single-item mode.
  void setBuyNowItem(CartModel item) {
    _buyNowItem = item;
    _isBuyNow = true;
    notifyListeners();
  }

  /// Reset to full-cart mode (call when leaving checkout or after success).
  void clearBuyNow() {
    _buyNowItem = null;
    _isBuyNow = false;
    notifyListeners();
  }

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<bool> placeOrder() async {
    _setLoading(true);
    final success = await locator<CheckoutController>().placeOrder();
    _setLoading(false);
    return success;
  }

  void setEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  void toggleEditing() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> saveCard(
      String cardNumber, String expiryDate, String securityCode) async {
    _setLoading(true);
    final success = await locator<CheckoutController>()
        .saveCard(cardNumber, expiryDate, securityCode);
    if (success) {
      _cardNumber = cardNumber;
      _expiryDate = expiryDate;
      _securityCode = securityCode;
      notifyListeners();
    }
    _setLoading(false);
    return success;
  }

  Future<void> loadSavedCard() async {
    final card = await locator<CheckoutController>().getSavedCard();
    _cardNumber = card['cardNumber'] ?? "";
    _expiryDate = card['expiryDate'] ?? "";
    _securityCode = card['securityCode'] ?? "";
    notifyListeners();
  }

  Future<void> clearCardDetails() async {
    await locator<CheckoutController>().clearCard();
    _cardNumber = "";
    _expiryDate = "";
    _securityCode = "";
    notifyListeners();
  }
}
