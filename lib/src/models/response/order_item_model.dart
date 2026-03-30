import 'package:json_annotation/json_annotation.dart';

part 'order_item_model.g.dart';

@JsonSerializable()
class OrderItemModel {
  @JsonKey(name: 'product_id')
  int? productId;

  @JsonKey(name: 'product_name')
  String? productName;

  @JsonKey(name: 'image')
  String? image;

  @JsonKey(name: 'quantity')
  int? quantity;

  @JsonKey(name: 'price_at_purchase')
  double? price;

  @JsonKey(name: 'item_total')
  double? total;

  OrderItemModel({
    this.productId,
    this.productName,
    this.image,
    this.quantity,
    this.price,
    this.total,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
}