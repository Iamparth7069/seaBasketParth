import 'package:json_annotation/json_annotation.dart';

part 'req_cart_model.g.dart';

@JsonSerializable()
class ReqCartModel {
  final int productId;
  final int quantity;
  final String size;

  ReqCartModel({
    required this.productId,
    required this.quantity,
    required this.size,
  });

  factory ReqCartModel.fromJson(Map<String, dynamic> json) =>
      _$ReqCartModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqCartModelToJson(this);
}
