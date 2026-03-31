import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import 'package:seabasket/src/base/extensions/scaffold_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/enum_utils.dart';
import 'package:seabasket/src/base/utils/image_utils.dart';
import 'package:seabasket/src/controllers/order_controller.dart';
import 'package:seabasket/src/models/response/res_my_order_model.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/providers/order_provider.dart';

class OrderHistory extends StatefulWidget {
  final int? orderId;

  const OrderHistory({super.key, this.orderId});

  @override
  State<OrderHistory> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistory> {
  final NumberFormat currencyFormat = NumberFormat.decimalPattern('en_in');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrderDetail();
    });
  }

  Future<void> _fetchOrderDetail() async {
    final provider = context.read<OrderProvider>();

    final orders =
        await locator<OrderController>().getMyOrders(orderId: widget.orderId);

    if (mounted) {
      provider.setOrderHistory(orders);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, child) {
        final _orders = provider.historyOrders;

        return (_orders.isEmpty
                ? const Center(child: Text("No orders found."))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _orderCard(_orders.first),
                  ))
            .commonScaffold(
          context: context,
          title: "Order History",
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        );
      },
    );
  }

  Widget _orderCard(ResMyOrderModel order) {
    OrderStatus getOrderStatus(String? status) {
      final value = status?.toLowerCase().trim() ?? "";

      if (value.contains("pack")) return OrderStatus.packing;
      if (value.contains("transit")) return OrderStatus.inTransit;
      if (value.contains("deliver")) return OrderStatus.delivered;

      return OrderStatus.placed;
    }

    final currentStatus = getOrderStatus(order.status);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order #${order.orderId ?? ''}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                order.status ?? '',
                style: TextStyle(
                  color: _getStatusColor(order.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (order.items != null && order.items!.isNotEmpty)
            Column(
              children: order.items!
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _productRow(item),
                    ),
                  )
                  .toList(),
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "No items found for this order.",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          const SizedBox(height: 12),
          _buildOrderStepper(currentStatus),
        ],
      ),
    );
  }

  Widget _productRow(dynamic item) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 65,
            height: 65,
            child: ImageUtils().getBase64Image(
              item.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Qty: ${item.quantity}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        Text(
          "₹ ${currencyFormat.format(item.price ?? 0)}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildOrderStepper(OrderStatus currentStatus) {
    const steps = OrderStatus.values;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          "Order Status",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...steps.map((step) {
          final isCompleted = step.index <= currentStatus.index;
          final isLast = step == steps.last;
          return _buildStep(
            title: step.displayTitle,
            subtitle: step.displaySubtitle,
            isCompleted: isCompleted,
            isLast: isLast,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildStep({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? primaryColor : Colors.transparent,
                border: Border.all(
                  color: isCompleted ? primaryColor : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.circle,
                      size: 12,
                      color: secondaryColor,
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: context.getHeight(0.07),
                color: isCompleted ? primaryColor : Colors.grey.shade300,
              ),
          ],
        ),
        SizedBox(width: context.getWidth(0.04)),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: fontSize16,
                  fontWeight: isCompleted ? fontWeightBold : fontWeightRegular,
                  color: isCompleted ? primaryTextColor : secondaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: context.getWidth(0.7),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: fontSize12,
                    color:
                        isCompleted ? secondaryTextColor : Colors.grey.shade400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    final statusValue = status?.toLowerCase().trim();

    switch (statusValue) {
      case "delivered":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      case "pending":
        return Colors.orange;
      case "packing":
        return Colors.blue;
      default:
        return Colors.blueGrey;
    }
  }
}
