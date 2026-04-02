import 'package:json_annotation/json_annotation.dart';
import 'package:seabasket/src/models/cart/cart_model.dart';
import 'package:seabasket/src/models/cart/cart_summary_model.dart';

part 'cart_data_model.g.dart';

@JsonSerializable()
class CartDataModel {
  final String status;
  @JsonKey(name: 'delivery_address')
  final String? deliveryAddress;
  final List<CartModel> items;
  final CartSummaryModel? summary;
  CartDataModel({
    required this.status,
    this.deliveryAddress,
    this.items = const [],
    this.summary,
  });

  factory CartDataModel.fromJson(Map<String, dynamic> json) =>
      _$CartDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartDataModelToJson(this);
}
