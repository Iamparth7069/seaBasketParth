import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:seabasket/src/apis/apimanagers/checkout_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';

class CheckoutController {
  Future<bool> processStripePayment({
    required double amount,
    required String name,
    required String email,
    required String phone,
    required Address address,
  }) async {
    final paymentIntent =
        await locator<CheckoutApiManager>().createPaymentIntentApiCall(amount);

    if (paymentIntent == null ||
        paymentIntent.data.clientSecret == null ||
        paymentIntent.data.paymentIntentId == null) {
      return false;
    }

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent.data.clientSecret,
        merchantDisplayName: 'seaBasket',
        allowsDelayedPaymentMethods: true,
        style: ThemeMode.light,
        billingDetails: BillingDetails(
          name: name,
          email: email,
          phone: phone,
          address: address,
        ),
      ),
    );

    await Stripe.instance.presentPaymentSheet();

    final confirmSuccess = await locator<CheckoutApiManager>()
        .confirmPaymentApiCall(paymentIntent.data.paymentIntentId!);

    return confirmSuccess;
  }
}
