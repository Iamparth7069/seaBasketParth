import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import 'package:seabasket/src/base/extensions/scaffold_extension.dart';
import 'package:seabasket/src/base/extensions/string_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/controllers/cart_controller.dart';
import 'package:seabasket/src/controllers/checkout_controller.dart';
import 'package:seabasket/src/providers/cart_provider.dart';
import 'package:seabasket/src/providers/checkout_provider.dart';
import 'package:seabasket/src/widgets/primary_button.dart';
import 'package:seabasket/src/widgets/primary_text_field.dart';

import '../controllers/auth/auth_controller.dart';

class CheckoutScreen extends StatefulWidget {
  final int? categoryId;
  const CheckoutScreen({super.key, this.categoryId});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _addressController;
  final NumberFormat _format = NumberFormat.decimalPattern('en_in');

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final checkoutProvider = context.read<CheckoutProvider>();

      final cartData =
          await locator<CartController>().getCartData(modify: true);
      if (cartData != null && mounted) {
        if (cartData.deliveryAddress != null &&
            cartData.deliveryAddress!.isNotEmpty) {
          _addressController.text = cartData.deliveryAddress!;
        }

        if (!checkoutProvider.isBuyNow) {
          context.read<CartProvider>().setCartItems(cartData.items);
        }
      }

      if (checkoutProvider.isBuyNow) {
        final buyNowCartItemId = checkoutProvider.buyNowItem?.cartItemId;
        if (buyNowCartItemId != null) {
          final updatedBuyNow = await locator<CartController>()
              .getCartItemPatch(buyNowCartItemId);
          if (updatedBuyNow != null && mounted) {
            checkoutProvider.setBuyNowItem(updatedBuyNow);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    //  context.read<CheckoutProvider>().clearBuyNow();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartProvider, CheckoutProvider>(
      builder: (context, cartProvider, checkoutProvider, child) {
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
                  Localization.of().deliveryAddressText,
                  style: const TextStyle(
                    fontSize: fontSize18,
                    fontWeight: fontWeightBold,
                    color: primaryTextColor,
                  ),
                ),
                SizedBox(height: context.getHeight(0.02)),
                _addressSection(checkoutProvider),
                SizedBox(height: context.getHeight(0.03)),
                const Divider(),
                SizedBox(height: context.getHeight(0.02)),
                Text(
                  Localization.of().orderSummaryText,
                  style: const TextStyle(
                    fontSize: fontSize18,
                    fontWeight: fontWeightBold,
                    color: primaryTextColor,
                  ),
                ),
                SizedBox(height: context.getHeight(0.02)),
                checkoutProvider.isBuyNow
                    ? _buyNowOrderSummary(checkoutProvider)
                    : _cartOrderSummary(cartProvider),
                SizedBox(height: context.getHeight(0.03)),
                checkoutProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : PrimaryButton(
                        buttonText: Localization.of().contiunePaymentText,
                        buttonColor: primaryButtonColor,
                        backgroundColor: primaryButtonColor,
                        trailingIcon: Icons.arrow_forward,
                        onButtonClick: _handleContinue,
                      ),
                SizedBox(height: context.getHeight(0.02)),
              ],
            ),
          ),
        ).commonScaffold(
          context: context,
          title: Localization.of().checkoutText,
          centerTitle: true,
          leading: IconButton(
            onPressed: locator<NavigationUtils>().pop,
            icon: const Icon(Icons.arrow_back),
          ),
        );
      },
    );
  }

  Widget _addressSection(CheckoutProvider checkoutProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryTextField(
          label: "",
          hint: Localization.of().addressHint,
          controller: _addressController,
          maxLines: 3,
          readOnly: !checkoutProvider.isEditing,
          contentPadding: const EdgeInsets.all(14),
          textInputAction: TextInputAction.done,
          validateFunction: (value) =>
              value?.isFieldEmpty(Localization.of().msgAddressEmpty),
        ),
        SizedBox(height: context.getHeight(0.01)),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () async {
              if (checkoutProvider.isEditing) {
                final newAddress = _addressController.text.trim();
                if (newAddress.isNotEmpty) {
                  await locator<AuthController>().updateProfile(
                    context,
                    address: newAddress,
                  );
                }
              }
              checkoutProvider.toggleEditing();
            },
            child: Text(
              checkoutProvider.isEditing
                  ? Localization.of().save
                  : Localization.of().changeText,
              style: const TextStyle(
                color: primaryButtonColor,
                fontWeight: fontWeightMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buyNowOrderSummary(CheckoutProvider checkoutProvider) {
    final item = checkoutProvider.buyNowItem;
    if (item == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: containerBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.isAvailable == false) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red.shade600, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      Localization.of().unavailableItemMessage,
                      style: TextStyle(
                        fontSize: fontSize12,
                        color: Colors.red.shade700,
                        fontWeight: fontWeightMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                if (item.image != null && item.image!.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      Uri.parse(item.image!).data!.contentAsBytes(),
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(
                        width: 64,
                        height: 64,
                        child: Icon(Icons.image_not_supported_outlined,
                            size: 28, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName ?? '',
                        style: const TextStyle(
                          fontSize: fontSize14,
                          fontWeight: fontWeightBold,
                          color: primaryTextColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${Localization.of().sizeText} : ${item.size ?? ''}',
                        style: const TextStyle(
                          fontSize: fontSize12,
                          color: secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${Localization.of().quantityText} : ${item.quantity ?? 1}',
                        style: const TextStyle(
                          fontSize: fontSize12,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹ ${_format.format(item.effectivePrice ?? 0)}',
                  style: const TextStyle(
                    fontSize: fontSize14,
                    fontWeight: fontWeightBold,
                    color: primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _summaryRow(
            Localization.of().subTotalText,
            '₹ ${_format.format(checkoutProvider.buyNowSubtotal)}',
          ),
          SizedBox(height: context.getHeight(0.01)),
          _summaryRow(
            Localization.of().shippingFeeText,
            '₹ ${_format.format(checkoutProvider.shippingFee)}',
          ),
          const Divider(height: 24),
          _summaryRow(
            Localization.of().totalText,
            '₹ ${_format.format(checkoutProvider.buyNowTotal)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _cartOrderSummary(CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: containerBorderColor),
      ),
      child: Column(
        children: [
          _summaryRow(
            Localization.of().subTotalText,
            '₹ ${_format.format(cartProvider.subtotal)}',
          ),
          SizedBox(height: context.getHeight(0.01)),
          _summaryRow(
            Localization.of().shippingFeeText,
            '₹ ${_format.format(cartProvider.shippingFee)}',
          ),
          const Divider(height: 24),
          _summaryRow(
            Localization.of().totalText,
            '₹ ${_format.format(cartProvider.total)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize14,
            color: primaryTextColor,
            fontWeight: isBold ? fontWeightBold : fontWeightRegular,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? fontSize18 : fontSize16,
            color: primaryTextColor,
            fontWeight: isBold ? fontWeightBold : fontWeightSemiBold,
          ),
        ),
      ],
    );
  }

  void _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final checkoutProvider = context.read<CheckoutProvider>();
    final cartProvider = context.read<CartProvider>();
    final double totalAmount = checkoutProvider.isBuyNow
        ? checkoutProvider.buyNowTotal
        : cartProvider.total;

    final result =
        await locator<CheckoutController>().processStripePayment(totalAmount);
    if (!mounted) return;
    if (result == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localization.of().paymentSuccessText),
          backgroundColor: Colors.green,
        ),
      );

      // checkoutProvider.clearBuyNow();
      locator<NavigationUtils>().pushReplacement(routeOrderDetail);
    } else if (result == 'canceled') {
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localization.of().paymentFailedText),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}
