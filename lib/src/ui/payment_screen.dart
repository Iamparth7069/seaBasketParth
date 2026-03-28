import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import 'package:seabasket/src/base/extensions/scaffold_extension.dart';
import 'package:seabasket/src/base/extensions/string_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/dialog_utils.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/providers/cart_provider.dart';
import 'package:seabasket/src/providers/checkout_provider.dart';
import 'package:seabasket/src/providers/order_provider.dart';
import 'package:seabasket/src/providers/order_status_provider.dart';
import 'package:seabasket/src/widgets/primary_button.dart';
import 'package:seabasket/src/widgets/primary_text_field.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cardNumberController;
  late TextEditingController _expiryDateController;
  late TextEditingController _securityCodeController;

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController();
    _expiryDateController = TextEditingController();
    _securityCodeController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final checkoutProvider = context.read<CheckoutProvider>();
      await checkoutProvider.loadSavedCard();
      _cardNumberController.text = checkoutProvider.cardNumber;
      _expiryDateController.text = checkoutProvider.expiryDate;
      _securityCodeController.text = checkoutProvider.securityCode;
    });
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _securityCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutProvider>(
      builder: (context, checkoutProvider, child) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.getWidth(0.05),
            vertical: context.getHeight(0.02),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Localization.of().addCardTitle,
                  style: const TextStyle(
                    fontSize: fontSize18,
                    fontWeight: fontWeightBold,
                    color: primaryTextColor,
                  ),
                ),
                SizedBox(height: context.getHeight(0.025)),
                PrimaryTextField(
                  contentPadding: const EdgeInsets.only(left: 4),
                  label: Localization.of().cardNumberLabel,
                  hint: "**** **** **** ****",
                  controller: _cardNumberController,
                  type: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  maxLength: 16,
                  validateFunction: (value) =>
                      value?.isFieldEmpty(Localization.of().validCardMessage),
                ),
                SizedBox(height: context.getHeight(0.025)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: PrimaryTextField(
                        contentPadding: EdgeInsets.only(left: 4),
                        label: Localization.of().expiryDateLabel,
                        hint: Localization.of().expiryDateHint,
                        controller: _expiryDateController,
                        type: TextInputType.text,
                        maxLength: 5,
                        textInputAction: TextInputAction.next,
                        validateFunction: (value) => value?.isValidExpiryDate(),
                      ),
                    ),
                    SizedBox(width: context.getWidth(0.04)),
                    Expanded(
                      child: PrimaryTextField(
                        contentPadding: const EdgeInsets.only(left: 4),
                        label: Localization.of().securityCodeLabel,
                        hint: Localization.of().securityCodeHint,
                        controller: _securityCodeController,
                        maxLength: 3,
                        type: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        validateFunction: (value) => value?.isFieldEmpty(
                            Localization.of().validSecurityCodeMessage),
                        suffixIcon: const Icon(
                          Icons.help_outline,
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                checkoutProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : PrimaryButton(
                        buttonText: Localization.of().placeOrderText,
                        buttonColor: primaryButtonColor,
                        backgroundColor: primaryButtonColor,
                        onButtonClick: _handlePlaceOrder,
                      ),
                SizedBox(height: context.getHeight(0.02)),
              ],
            ),
          ),
        ).commonScaffold(
          context: context,
          title: Localization.of().cardDetailsText,
          centerTitle: true,
          leading: IconButton(
            onPressed: locator<NavigationUtils>().pop,
            icon: const Icon(Icons.arrow_back),
          ),
        );
      },
    );
  }

  void _handlePlaceOrder() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    await context.read<CheckoutProvider>().saveCard(
          _cardNumberController.text,
          _expiryDateController.text,
          _securityCodeController.text,
        );

    final success = await context.read<CheckoutProvider>().placeOrder();

    // if (success && mounted) {
    //   await context.read<OrderProvider>().saveOrderesFromCart(
    //         context.read<CartProvider>().cartItems,
    //         context.read<CartProvider>().total,
    //         context.read<CartProvider>().shippingFee,
    //       );
    //   context.read<CartProvider>().clearCart();
    //   await context.read<CartProvider>().loadCartItems();
    //   //await context.read<OrderStatusProvider>().loadOrderStatus();
    //   if (mounted) _showSuccessDialog();
    // }
  }

  void _showSuccessDialog() {
    showAlertDialog(
      isCancelEnable: false,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: successColor,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text(
              Localization.of().orderPlacedText,
              style: const TextStyle(
                fontSize: fontSize24,
                fontWeight: fontWeightBold,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              Localization.of().orderPlacedSubText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: fontSize14,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              buttonText: Localization.of().trackOrderText,
              buttonColor: primaryButtonColor,
              backgroundColor: primaryButtonColor,
              textColor: secondaryColor,
              onButtonClick: () {
                locator<NavigationUtils>().pop();
                locator<NavigationUtils>().pushReplacement(routeOrderStatus);
              },
            ),
          ],
        ),
      ),
    );
  }
}
