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
    final orders = await locator<OrderController>().getMyOrders();

    provider.setMyOrders(orders);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<OrderProvider, UserProvider>(
      builder: (context, orderProvider, userProvider, child) {
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
                locator<NavigationUtils>().push(routeOrderHistory,
                    arguments: {paramOrderId: order.orderId});
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
                          "Order Id #${order.orderId}",
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
                                ? Colors.green.withAlpha(25)
                                : primaryColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order.status?.toUpperCase() ?? "In procsess",
                            style: TextStyle(
                              fontSize: fontSize12,
                              fontWeight: fontWeightBold,
                              color:
                              (order.status?.toLowerCase() == 'deliverd' ||
                                  order.status?.toLowerCase() ==
                                      'delivered')
                                  ? Colors.green
                                  : primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.payment_sharp,
                          size: 14,
                          color: secondaryTextColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${order.orderId}",
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
                          "${Localization.of().totalText} : ₹ ${currencyFormat.format(order.totalAmount ?? 0.0)}",
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
              ),
            );
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