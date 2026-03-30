import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import 'package:seabasket/src/base/extensions/scaffold_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/constants/dic_params.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/controllers/order_controller.dart';
import 'package:seabasket/src/providers/order_provider.dart';
import 'package:seabasket/src/providers/user_provider.dart';

import '../providers/bottom_nav_provider.dart';
import '../providers/order_status_provider.dart';

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
      _fetchOrders();
    });
  }

  Future<void> _fetchOrders() async {
    final provider = context.read<OrderProvider>();
    provider.setLoading(true);
    final response = await locator<OrderController>().getMyOrders();
    if (response != null) {
      provider.setMyOrders(response);
    } else {
      provider.setMyOrders([]);
    }
    provider.setLoading(false);
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

        if (orderProvider.myOrders.isEmpty) {
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

        final myOrders = orderProvider.myOrders;

        return ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: context.getWidth(0.05),
            vertical: context.getHeight(0.02),
          ),
          itemCount: myOrders.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final order = myOrders[index];

            return GestureDetector(
              onTap: () {
                locator<NavigationUtils>().push(routeOrderStatus, arguments: {
                  paramOrderId: order.orderId?.toString(),
                  paramOrderStatus: order.status,
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: containerBorderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order #${order.orderId ?? 'N/A'}",
                        style: const TextStyle(
                          fontSize: fontSize16,
                          fontWeight: fontWeightBold,
                          color: primaryTextColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: (order.status?.toLowerCase() == 'deliverd' ||
                                  order.status?.toLowerCase() == 'delivered')
                              ? Colors.green.withOpacity(0.1)
                              : primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order.status?.toUpperCase() ?? 'UNKNOWN',
                          style: TextStyle(
                            fontSize: fontSize12,
                            fontWeight: fontWeightBold,
                            color: (order.status?.toLowerCase() == 'deliverd' ||
                                    order.status?.toLowerCase() == 'delivered')
                                ? Colors.green
                                : primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: secondaryTextColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        order.placedAt != null
                            ? DateFormat('dd MMM yyyy, hh:mm a').format(
                                DateTime.tryParse(order.placedAt!) ??
                                    DateTime.now())
                            : 'Date not available',
                        style: const TextStyle(
                          fontSize: fontSize14,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.payments_outlined,
                        size: 16,
                        color: secondaryTextColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Total: ₹ ${currencyFormat.format(order.totalAmount ?? 0.0)}",
                        style: const TextStyle(
                          fontSize: fontSize14,
                          fontWeight: fontWeightSemiBold,
                          color: primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ),);
          },
        );
      },
    ).commonScaffold(
      context: context,
      title: Localization.of().orderDetailText,
      centerTitle: true,
      leading: IconButton(
        onPressed: _handleToHomeScreen,
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }

  void _handleToHomeScreen() {
    context.read<OrderStatusProvider>().reset();
    context.read<BottomNavProvider>().changeTab(0);
    locator<NavigationUtils>().pushAndRemoveUntil(routeBase);
  }
}
