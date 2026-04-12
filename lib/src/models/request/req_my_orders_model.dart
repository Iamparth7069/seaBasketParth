import 'package:json_annotation/json_annotation.dart';

part 'req_my_orders_model.g.dart';

@JsonSerializable()
class ReqMyOrdersModel {
  @JsonKey(name: 'order_id')
  final int? orderId;

  ReqMyOrdersModel({this.orderId});

  factory ReqMyOrdersModel.fromJson(Map<String, dynamic> json) =>
      _$ReqMyOrdersModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReqMyOrdersModelToJson(this);
}
