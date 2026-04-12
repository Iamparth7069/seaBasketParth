import 'package:json_annotation/json_annotation.dart';
import 'package:seabasket/src/base/utils/enum_utils.dart';

part 'req_update_cart_model.g.dart';

@JsonSerializable()
class ReqUpdateCartModel {
  @JsonKey(name: "cart_item_id")
  final int? cartItemId;

  @JsonKey(name: "value")
  final CartActionType? action;

  ReqUpdateCartModel({
    this.cartItemId,
    this.action,
  });

  factory ReqUpdateCartModel.fromJson(Map<String, dynamic> json) =>
      _$ReqUpdateCartModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqUpdateCartModelToJson(this);
}
