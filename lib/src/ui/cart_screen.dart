import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/constants/image_constant.dart';
import 'package:seabasket/src/base/utils/image_utils.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/controllers/cart_controller.dart';
import 'package:seabasket/src/providers/cart_provider.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/providers/user_provider.dart';
import 'package:seabasket/src/widgets/login_required_widget.dart';
import 'package:seabasket/src/widgets/primary_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final NumberFormat currencyFormat = NumberFormat.decimalPattern('en_in');
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cartData =
          await locator<CartController>().getCartData(modify: true);
      if (cartData != null) {
        context.read<CartProvider>().setCartItems(cartData.items);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartProvider, UserProvider>(
      builder: (context, cartProvider, userProvider, child) {
        if (!userProvider.isLoggedIn) {
          return const LoginRequiredWidget();
        }
        if (cartProvider.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  size: 64,
                ),
                const SizedBox(height: 24),
                Text(
                  Localization.of().cartEmptyText,
                  style: const TextStyle(
                    fontSize: fontSize20,
                    fontWeight: fontWeightSemiBold,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  Localization.of().cartEmptySubText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: fontSize16,
                    color: secondaryTextColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      itemCount: cartProvider.cartItems.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _cartItem(cartProvider, index);
                      },
                    ),
                    _subtotalSection(cartProvider),
                  ],
                ),
              ),
            ),
            _bottomButton(),
          ],
        );
      },
    );
  }

  Widget _cartItem(CartProvider cartProvider, int index) {
    final item = cartProvider.cartItems[index];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: containerBorderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 80,
              height: 80,
              child: ImageUtils().getBase64Image(
                item.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.productName ?? '',
                        style: const TextStyle(
                          fontSize: fontSize14,
                          fontWeight: fontWeightBold,
                          color: primaryTextColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                        onTap: () async {
                          final itemId = item.cartItemId;
                          if (itemId != null) {
                            cartProvider.removeItem(index);
                            final data = await locator<CartController>()
                                .removeFromCart(itemId, true);
                            if (mounted && data != null) {
                              context
                                  .read<CartProvider>()
                                  .setCartItems(data.items);
                            }
                          }
                        },
                        child: SvgPicture.asset(deleteIcon)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.size ?? '',
                  style: const TextStyle(
                    fontSize: fontSize12,
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹  ${currencyFormat.format(item.effectivePrice ?? 0)}",
                      style: const TextStyle(
                        fontSize: fontSize14,
                        fontWeight: fontWeightBold,
                        color: primaryTextColor,
                      ),
                    ),
                    Row(
                      children: [
                        _quantityButton(
                          icon: Icons.remove,
                          onTap: () => locator<CartController>().updateQuantity(
                            cartProvider: cartProvider,
                            index: index,
                            value: "decrease",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontSize: fontSize14,
                            fontWeight: fontWeightMedium,
                          ),
                        ),
                        const SizedBox(width: 16),
                        _quantityButton(
                          icon: Icons.add,
                          onTap: () => locator<CartController>().updateQuantity(
                            cartProvider: cartProvider,
                            index: index,
                            value: "increase",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: containerBorderColor),
        ),
        child: Icon(icon, size: 16, color: primaryTextColor),
      ),
    );
  }

  Widget _subtotalSection(CartProvider cartProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.getWidth(0.06),
          vertical: context.getHeight(0.01)),
      child: Column(
        children: [
          _summaryDetail(Localization.of().subTotalText,
              "₹ ${currencyFormat.format(cartProvider.subtotal)}"),
          const SizedBox(height: 16),
          _summaryDetail(Localization.of().shippingFeeText,
              "₹ ${currencyFormat.format(cartProvider.shippingFee)}"),
          const Divider(color: containerBorderColor, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Localization.of().totalText,
                style: const TextStyle(
                  fontSize: fontSize16,
                  color: primaryTextColor,
                ),
              ),
              Text(
                "₹ ${currencyFormat.format(cartProvider.total)}",
                style: const TextStyle(
                  fontSize: fontSize18,
                  fontWeight: fontWeightBold,
                  color: primaryTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _bottomButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.getWidth(0.04),
          vertical: context.getHeight(0.02)),
      child: PrimaryButton(
        buttonText: Localization.of().goToCheckoutText,
        buttonColor: primaryButtonColor,
        backgroundColor: primaryButtonColor,
        trailingIcon: Icons.arrow_forward,
        onButtonClick: () {
          locator<NavigationUtils>().push(routeCheckout);
        },
      ),
    );
  }

  Widget _summaryDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: fontSize14,
            color: secondaryTextColor,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: fontSize14,
            fontWeight: fontWeightSemiBold,
            color: primaryTextColor,
          ),
        ),
      ],
    );
  }
}
