import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ReqUpdateCartModel {
  int? cartItemId;
  String? value;

  ReqUpdateCartModel({
    this.cartItemId,
    this.value,
  });
  Map<String, dynamic> toJson() => {
        "cart_item_id": cartItemId,
        "value": value,
      };
}
