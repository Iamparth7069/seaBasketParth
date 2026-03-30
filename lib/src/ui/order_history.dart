import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/image_utils.dart';
import 'package:seabasket/src/controllers/order_controller.dart';
import 'package:seabasket/src/models/response/res_my_order_model.dart';

class OrderHistory extends StatefulWidget {
  final int? orderId;

  const OrderHistory({super.key, this.orderId});

  @override
  State<OrderHistory> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistory> {
  final NumberFormat currencyFormat = NumberFormat.decimalPattern('en_in');

  // ✅ Local state — completely independent from OrderProvider
  List<ResMyOrderModel> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetail();
  }

  Future<void> _fetchOrderDetail() async {
    final orders =
    await locator<OrderController>().getMyOrders(orderId: widget.orderId);

    // 🔍 Debug — remove after fixing
    debugPrint('Orders count: ${orders.length}');
    for (final order in orders) {
      debugPrint('Order ID: ${order.orderId}');
      debugPrint('Items count: ${order.items?.length}');
      debugPrint('Items: ${order.items}');
    }

    if (mounted) {
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
          ? const Center(child: Text("No orders found."))
          : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _orders.length,
          separatorBuilder: (context, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _orderCard(_orders[index]);
      },
    ),
    );
  }

  Widget _orderCard(ResMyOrderModel order) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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

          // ✅ Guard against null items
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

          const SizedBox(height: 10),

          Divider(color: Colors.grey.shade300),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "₹ ${currencyFormat.format(order.totalAmount ?? 0)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
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

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "delivered":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      case "pending":
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }
}