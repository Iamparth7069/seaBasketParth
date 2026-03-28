import 'package:json_annotation/json_annotation.dart';
import 'package:seabasket/src/models/cart/cart_data_model.dart';

part 'res_update_cart_model.g.dart';

@JsonSerializable()
class ResUpdateCartModel {
  final CartDataModel data;

  ResUpdateCartModel({
    required this.data,
  });

  factory ResUpdateCartModel.fromJson(Map<String, dynamic> json) =>
      _$ResUpdateCartModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResUpdateCartModelToJson(this);
}
