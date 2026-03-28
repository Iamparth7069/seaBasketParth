import 'package:seabasket/src/apis/apimanagers/checkout_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';

class CheckoutController {
  Future<bool> placeOrder() async {
    return await locator<CheckoutApiManager>().placeOrderApiCall();
  }

  Future<bool> saveCard(
      String cardNumber, String expiryDate, String securityCode) async {
    return await locator<CheckoutApiManager>()
        .saveCardApiCall(cardNumber, expiryDate, securityCode);
  }

  Future<Map<String, String>> getSavedCard() async {
    return await locator<CheckoutApiManager>().getSavedCardApiCall();
  }

  Future<void> clearCard() async {
    await locator<CheckoutApiManager>().clearCardApiCall();
  }
}
