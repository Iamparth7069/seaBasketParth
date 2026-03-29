import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
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

  Future<String> processStripePayment(double amount) async {
    try {
      // 1. Fetch Payment Intent from backend
      final paymentIntent =
          await locator<CheckoutApiManager>().createPaymentIntentApiCall(amount);

      if (paymentIntent == null ||
          paymentIntent.data.clientSecret == null ||
          paymentIntent.data.paymentIntentId == null) {
        return 'Server failed to return payment intent';
      }

      // 2. Initialize Stripe Payment Sheet
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

      // 3. Present the Payment Sheet UI
      await Stripe.instance.presentPaymentSheet();

      // 4. If UI presentation succeeds, confirm with the backend
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
        return e.error.localizedMessage ?? 'Stripe Native Error: ${e.error.code}';
      }
    } catch (e) {
      return 'Unexpected Error: $e';
    }
  }
}
