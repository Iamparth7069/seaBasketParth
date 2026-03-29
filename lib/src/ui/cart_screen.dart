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
import 'package:seabasket/src/models/cart_item.dart';
import 'package:seabasket/src/models/request/req_update_cart_model.dart';
import 'package:seabasket/src/providers/cart_provider.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/providers/user_provider.dart';
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
      final cartData = await locator<CartController>().getCartData(modify: true);
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
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: context.getHeight(0.02),
                vertical: context.getHeight(0.07)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: profileContainerColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 48,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  Localization.of().notLoggedIn,
                  style: const TextStyle(
                    fontSize: fontSize18,
                    fontWeight: fontWeightSemiBold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  Localization.of().loginMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      locator<NavigationUtils>().push(routeLogin);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      Localization.of().loginText,
                      style: const TextStyle(
                        fontSize: fontSize16,
                        fontWeight: fontWeightSemiBold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
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

  // Tracks which cart item indices are currently loading (qty update in progress)
  final Set<int> _loadingIndices = {};

  Future<void> _updateQuantity(
      bool modify,
    CartProvider cartProvider,
    int index,
    String direction, // "increase" or "decrease"
  ) async {
    final item = cartProvider.cartItems[index];
    if (item.cartItemId == null) return;

    // Decrease at qty=1 → remove item
    if (direction == "decrease" && (item.quantity ?? 1) <= 1) {
      cartProvider.removeItem(index);
      final data = await locator<CartController>()
          .removeFromCart(item.cartItemId!,modify);
      if (!mounted) return;
      if (data != null) {
        context.read<CartProvider>().setCartItems(data.items);
      }
      return;
    }

    // Optimistic UI update
    setState(() => _loadingIndices.add(index));
    cartProvider.updateItemQuantity(
      index,
      direction == "increase"
          ? (item.quantity ?? 0) + 1
          : (item.quantity ?? 1) - 1,
    );

    // API call
    final data = await locator<CartController>().getCartData(
      item: ReqUpdateCartModel(
        cartItemId: item.cartItemId,
        value: direction,
      ),
      modify: modify,
    );

    if (!mounted) return;

    // Sync from server
    if (data != null) {
      context.read<CartProvider>().setCartItems(data.items);
    }

    setState(() => _loadingIndices.remove(index));
  }


  Widget _cartItem(CartProvider cartProvider, int index) {
    final item = cartProvider.cartItems[index];
    final isLoading = _loadingIndices.contains(index);

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
                                .removeFromCart(itemId,true);
                            if (mounted && data != null) {
                              context.read<CartProvider>().setCartItems(data.items);
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
                          isLoading: isLoading,
                          onTap: isLoading
                              ? null
                              : () => _updateQuantity(false,
                                    cartProvider, index, "decrease"),
                        ),
                        const SizedBox(width: 16),
                        isLoading
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: primaryColor,
                                ),
                              )
                            : Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontSize: fontSize14,
                                  fontWeight: fontWeightMedium,
                                ),
                              ),
                        const SizedBox(width: 16),
                        _quantityButton(
                          icon: Icons.add,
                          isLoading: isLoading,
                          onTap: isLoading
                              ? null
                              : () => _updateQuantity(false,
                                    cartProvider, index, "increase"),
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
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isLoading ? Colors.grey.shade300 : containerBorderColor,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isLoading ? Colors.grey.shade400 : primaryTextColor,
        ),
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
