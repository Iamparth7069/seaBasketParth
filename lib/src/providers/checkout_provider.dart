import 'package:flutter/material.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/controllers/checkout_controller.dart';

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
