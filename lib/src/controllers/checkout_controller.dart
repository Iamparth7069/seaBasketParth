import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:seabasket/src/apis/apimanagers/checkout_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';

class CheckoutController {
  Future<String> processStripePayment(double amount) async {
    try {
      final paymentIntent = await locator<CheckoutApiManager>()
          .createPaymentIntentApiCall(amount);

      if (paymentIntent == null ||
          paymentIntent.data.clientSecret == null ||
          paymentIntent.data.paymentIntentId == null) {
        return 'Server failed to return payment intent';
      }
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent.data.clientSecret,
          merchantDisplayName: 'seaBasket',
          allowsDelayedPaymentMethods: true,
          style: ThemeMode.light,
          billingDetails: const BillingDetails(
            name: 'seaBasket Customer',
            email: 'customer@seabasket.com',
            phone: '+919876543210',
            address: Address(
              country: 'IN',
              city: 'Mumbai',
              line1: '123 Test Street',
              line2: '',
              postalCode: '400001',
              state: 'Maharashtra',
            ),
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      final confirmSuccess = await locator<CheckoutApiManager>()
          .confirmPaymentApiCall(paymentIntent.data.paymentIntentId!);

      if (!confirmSuccess) {
        return 'Server failed to confirm the payment';
      }

      return 'success';
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return 'canceled';
      } else {
        return e.error.localizedMessage ??
            'Stripe Native Error: ${e.error.code}';
      }
    } catch (e) {
      return 'Unexpected Error: $e';
    }
  }
}
