import 'package:seabasket/src/apis/api_route_constant.dart';
import 'package:seabasket/src/apis/api_service.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/constants/preference_key_constant.dart';
import 'package:seabasket/src/base/utils/preference_utils.dart';
import 'package:seabasket/src/models/response/res_payment_intent_model.dart';

class CheckoutApiManager {
  Future<bool> placeOrderApiCall() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Future<bool> saveCardApiCall(
      String cardNumber, String expiryDate, String securityCode) async {
    await Future.delayed(const Duration(milliseconds: 200));
    setString(prefkeyCardNumber, cardNumber);
    setString(prefkeyExpiryDate, expiryDate);
    setString(prefkeySecurityCode, securityCode);
    return true;
  }

  Future<ResPaymentIntentModel?> createPaymentIntentApiCall(
      double amount) async {
    final response = await locator<ApiService>().post(
      apiPaymentIntent,
      // Pass any payload if required by backend, else empty
      data: {
        "amount": amount,
      },
    );

    if (response != null) {
      return ResPaymentIntentModel.fromJson(response.data);
    }
    return null;
  }

  Future<bool> confirmPaymentApiCall(String paymentIntentId) async {
    final response = await locator<ApiService>().post(
      apiConfirmPayment,
      params: {
        "payment_intent_id": paymentIntentId,
      },
    );

    // Assuming a 200 OK means success Confirm.
    return response != null && response.statusCode == 200;
  }

  Future<Map<String, String>> getSavedCardApiCall() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'cardNumber': getString(prefkeyCardNumber),
      'expiryDate': getString(prefkeyExpiryDate),
      'securityCode': getString(prefkeySecurityCode),
    };
  }

  Future<void> clearCardApiCall() async {
    await Future.delayed(const Duration(milliseconds: 200));
    setString(prefkeyCardNumber, "");
    setString(prefkeyExpiryDate, "");
    setString(prefkeySecurityCode, "");
  }
}
