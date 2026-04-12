import 'package:dio/dio.dart';
import 'package:seabasket/src/apis/api_route_constant.dart';
import 'package:seabasket/src/apis/api_service.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/models/response/res_payment_intent_model.dart';

class CheckoutApiManager {
  Future<ResPaymentIntentModel?> createPaymentIntentApiCall(
      double amount) async {
    final response = await locator<ApiService>().post(
      apiPaymentIntent,
      data: {paramAmount: amount},
    );
    return ResPaymentIntentModel.fromJson(response!.data);
  }

  Future<Response> confirmPaymentApiCall(String paymentIntentId) async {
    final response = await locator<ApiService>().post(
      apiConfirmPayment,
      params: {
        paramPaymentIntentId: paymentIntentId,
      },
    );
    return response!;
  }
}
