import 'package:json_annotation/json_annotation.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartModel {
  String? message;
  @JsonKey(name: 'cart_item_id')
  int? cartItemId;
  @JsonKey(name: 'product_id')
  int? productId;
  @JsonKey(name: 'product_name')
  String? productName;
  @JsonKey(name: 'effective_price')
  double? effectivePrice;
  @JsonKey(name: 'item_subtotal')
  double? itemSubtotal;
  String? image;
  String? size;
  int? quantity;

  CartModel({
    this.message,
    this.cartItemId,
    this.productId,
    this.size,
    this.quantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartModelToJson(this);
}
