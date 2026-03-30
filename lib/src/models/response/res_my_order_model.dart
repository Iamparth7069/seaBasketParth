import 'package:json_annotation/json_annotation.dart';

part 'res_my_order_model.g.dart';

@JsonSerializable()
class ResMyOrderModel {
  @JsonKey(name: 'order_id')
  final int? orderId;
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'total_amount')
  final double? totalAmount;
  @JsonKey(name: 'placed_at')
  final String? placedAt;

  ResMyOrderModel({
    this.orderId,
    this.status,
    this.totalAmount,
    this.placedAt,
  });

  factory ResMyOrderModel.fromJson(Map<String, dynamic> json) =>
      _$ResMyOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResMyOrderModelToJson(this);
}
