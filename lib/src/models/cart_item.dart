import 'package:json_annotation/json_annotation.dart';

part 'cart_item.g.dart';

@JsonSerializable()
class CartItem {
  final int? id;
  final String? name;
  final String? size;
  final double? price;
  int? quantity;
  final String? image;

  CartItem({
    this.id,
    this.name,
    this.size,
    this.price,
    this.quantity = 1,
    this.image,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
