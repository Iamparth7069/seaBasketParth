import 'package:json_annotation/json_annotation.dart';
import 'package:seabasket/src/models/cart/cart_model.dart';

part 'res_cart_model.g.dart';

@JsonSerializable()
class ResCartModel {
  final CartModel data;
  final String message;

  ResCartModel({
    required this.data,
    required this.message,
  });

  factory ResCartModel.fromJson(Map<String, dynamic> json) =>
      _$ResCartModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResCartModelToJson(this);
}
