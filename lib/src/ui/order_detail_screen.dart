import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import 'package:seabasket/src/base/extensions/scaffold_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/providers/order_provider.dart';
import 'package:seabasket/src/providers/user_provider.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final NumberFormat currencyFormat = NumberFormat.decimalPattern('en_in');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<OrderProvider, UserProvider>(
      builder: (context, orderProvider, userProvider, child) {
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

        if (orderProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        if (orderProvider.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  size: 64,
                  color: secondaryTextColor,
                ),
                const SizedBox(height: 24),
                Text(
                  Localization.of().emptyOrderMessage,
                  style: const TextStyle(
                    fontSize: fontSize20,
                    fontWeight: fontWeightSemiBold,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  Localization.of().emptyOrderSubMessage,
                  style: const TextStyle(
                    fontSize: fontSize14,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          );
        }

        final groupOrder = orderProvider.groupedOrders;

        return ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: context.getWidth(0.05),
            vertical: context.getHeight(0.02),
          ),
          itemCount: groupOrder.length,
          separatorBuilder: (context, index) => const Divider(height: 32),
          itemBuilder: (context, index) {
            final orderId = groupOrder.keys.elementAt(index);
            final orderItems = groupOrder[orderId]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...orderItems.map((order) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
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
                              child: Image.asset(
                                order.image,
                                width: context.getWidth(0.20),
                                height: context.getHeight(0.10),
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.name,
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
                                    "${Localization.of().sizeText}${order.size}",
                                    style: const TextStyle(
                                      fontSize: fontSize12,
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${Localization.of().quantityText} ${order.quantity}",
                                    style: const TextStyle(
                                      fontSize: fontSize12,
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "₹ ${currencyFormat.format(order.price)}",
                                    style: const TextStyle(
                                      fontSize: fontSize14,
                                      fontWeight: fontWeightBold,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Localization.of().shippingText,
                            style: const TextStyle(
                              fontSize: fontSize14,
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            "₹ ${currencyFormat.format(orderItems.first.shippingFee)}",
                            style: const TextStyle(
                              fontSize: fontSize14,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Localization.of().orderTotalText,
                            style: const TextStyle(
                              fontSize: fontSize16,
                              fontWeight: fontWeightBold,
                              color: primaryTextColor,
                            ),
                          ),
                          Text(
                            "₹ ${currencyFormat.format(orderItems.first.totalAmount)}",
                            style: const TextStyle(
                              fontSize: fontSize16,
                              fontWeight: fontWeightBold,
                              color: primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    ).commonScaffold(
      context: context,
      title: Localization.of().orderDetailText,
      centerTitle: true,
      leading: IconButton(
        onPressed: locator<NavigationUtils>().pop,
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }
}
