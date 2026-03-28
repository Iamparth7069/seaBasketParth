import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  final String orderId;
  final String productId;
  final String name;
  final String size;
  final double price;
  final int quantity;
  final String image;
  final double totalAmount;
  final double shippingFee;

  Order({
    required this.orderId,
    required this.productId,
    required this.name,
    required this.size,
    required this.price,
    required this.quantity,
    required this.image,
    required this.totalAmount,
    required this.shippingFee,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
