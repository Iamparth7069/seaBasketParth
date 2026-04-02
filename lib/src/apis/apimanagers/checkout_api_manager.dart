import 'package:seabasket/src/apis/api_route_constant.dart';
import 'package:seabasket/src/apis/api_service.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/models/response/res_payment_intent_model.dart';

class CheckoutApiManager {
  Future<ResPaymentIntentModel?> createPaymentIntentApiCall(
      double amount) async {
    final response = await locator<ApiService>().post(
      apiPaymentIntent,
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
    return response != null && response.statusCode == 200;
  }
}
