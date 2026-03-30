import 'package:json_annotation/json_annotation.dart';

part 'res_order_status_model.g.dart';

@JsonSerializable()
class ResOrderStatusWrapper {
  @JsonKey(name: 'data')
  final ResOrderStatusModel? data;
  @JsonKey(name: 'message')
  final String? message;

  ResOrderStatusWrapper({this.data, this.message});

  factory ResOrderStatusWrapper.fromJson(Map<String, dynamic> json) =>
      _$ResOrderStatusWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$ResOrderStatusWrapperToJson(this);
}

@JsonSerializable()
class ResOrderStatusModel {
  @JsonKey(name: 'order_id')
  final int? orderId;
  @JsonKey(name: 'order_status')
  final String? orderStatus;

  ResOrderStatusModel({this.orderId, this.orderStatus});

  factory ResOrderStatusModel.fromJson(Map<String, dynamic> json) =>
      _$ResOrderStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResOrderStatusModelToJson(this);
}
