import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/apis/apimanagers/checkout_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/dic_params.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/controllers/auth/auth_controller.dart';
import 'package:seabasket/src/controllers/cart_controller.dart';
import 'package:seabasket/src/models/req_stripe_payment.dart';
import 'package:seabasket/src/models/request/req_update_profile_model.dart';
import 'package:seabasket/src/providers/cart_provider.dart';
import 'package:seabasket/src/providers/checkout_provider.dart';
import 'package:seabasket/src/providers/user_provider.dart';

class CheckoutController {
  Future<int?> processStripePayment(ReqStripePaymentModel request) async {
    final paymentIntent = await locator<CheckoutApiManager>()
        .createPaymentIntentApiCall(request.amount);

    if (paymentIntent == null ||
        paymentIntent.data.clientSecret == null ||
        paymentIntent.data.paymentIntentId == null) {
      throw Exception('Payment intent not returned by server');
    }

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent.data.clientSecret,
        merchantDisplayName: 'seaBasket',
        allowsDelayedPaymentMethods: true,
        style: ThemeMode.light,
        billingDetails: BillingDetails(
          name: request.name,
          email: request.email,
          phone: request.phone,
          address: request.address,
        ),
      ),
    );

    await Stripe.instance.presentPaymentSheet();

    final response = await locator<CheckoutApiManager>()
        .confirmPaymentApiCall(paymentIntent.data.paymentIntentId!);

    return response.data['data']['order_id'];
  }

  Future<void> loadCheckoutData(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final cartData = await locator<CartController>().updateCartAndGetData(
      dismissProgress: true,
    );

    if (cartData != null &&
        cartData.deliveryAddress != null &&
        cartData.deliveryAddress!.isNotEmpty) {
      controller.text = cartData.deliveryAddress!;
    }
  }

  Future<void> toggleAddressEdit({
    required BuildContext context,
    required CheckoutProvider provider,
    required String address,
  }) async {
    if (provider.isEditing && address.isNotEmpty) {
      await locator<AuthController>().updateProfile(
        context,
        ReqUpdateProfileModel(address: address),
      );
    }

    provider.toggleEditing();
  }

  Future<void> handleCheckout({
    required BuildContext context,
    required String address,
  }) async {
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localization.of().msgAddressEmpty),
        ),
      );
      return;
    }
    final cartProvider = context.read<CartProvider>();
    final user = context.read<UserProvider>().currentUser;

    if (user == null) return;

    final orderId = await processStripePayment(
      ReqStripePaymentModel(
        amount: cartProvider.total,
        name: user.username ?? '',
        email: user.email,
        phone: user.phoneNumber ?? '',
        address: Address(
          line1: address,
          line2: '',
          city: 'Ahemdabad',
          state: 'Gujarat',
          postalCode: '400001',
          country: 'IN',
        ),
      ),
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(Localization.of().paymentSuccessText),
        backgroundColor: successColor,
      ),
    );

    locator<NavigationUtils>()
        .pushReplacement(routeOrderDetail, arguments: {paramOrderId: orderId});
  }
}
