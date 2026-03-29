import 'package:flutter/material.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/controllers/checkout_controller.dart';
import 'package:seabasket/src/models/cart/cart_model.dart';

import '../base/utils/progress_dialog_utils.dart';

class CheckoutProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  String _cardNumber = "";
  String get cardNumber => _cardNumber;

  String _expiryDate = "";
  String get expiryDate => _expiryDate;

  String _securityCode = "";
  String get securityCode => _securityCode;

  bool _isBuyNow = false;
  bool get isBuyNow => _isBuyNow;

  CartModel? _buyNowItem;
  CartModel? get buyNowItem => _buyNowItem;

  double get buyNowSubtotal =>
      (_buyNowItem?.effectivePrice ?? 0) * (_buyNowItem?.quantity ?? 1);

  final double shippingFee = 80.0;

  double get buyNowTotal => buyNowSubtotal + shippingFee;

  void setBuyNowItem(CartModel item) {
    _buyNowItem = item;
    _isBuyNow = true;
    notifyListeners();
  }

  void clearBuyNow() {
    _buyNowItem = null;
    _isBuyNow = false;
    notifyListeners();
  }

  Future<bool> placeOrder() async {
    ProgressDialogUtils.showProgressDialog();
    final success = await locator<CheckoutController>().placeOrder();
    ProgressDialogUtils.dismissProgressDialog();
    return success;
  }

  Future<String> processStripePayment(double amount) async {
    ProgressDialogUtils.showProgressDialog();

    final result = await locator<CheckoutController>().processStripePayment(amount);
    ProgressDialogUtils.dismissProgressDialog();
    return result;
  }

  void setEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  void toggleEditing() {
    _isEditing = !_isEditing;
    notifyListeners();
  }



  Future<bool> saveCard(
      String cardNumber, String expiryDate, String securityCode) async {
    ProgressDialogUtils.showProgressDialog();

    final success = await locator<CheckoutController>()
        .saveCard(cardNumber, expiryDate, securityCode);
    if (success) {
      _cardNumber = cardNumber;
      _expiryDate = expiryDate;
      _securityCode = securityCode;
      notifyListeners();
    }
    ProgressDialogUtils.dismissProgressDialog();
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
