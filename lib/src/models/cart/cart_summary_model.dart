import 'package:json_annotation/json_annotation.dart';

part 'cart_summary_model.g.dart';

@JsonSerializable()
class CartSummaryModel {
  final double subtotal;
  final double shipping;

  @JsonKey(name: 'grand_total')
  final double grandTotal;

  CartSummaryModel({
    required this.subtotal,
    required this.shipping,
    required this.grandTotal,
  });

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$CartSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartSummaryModelToJson(this);
}
