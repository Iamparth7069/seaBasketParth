import 'package:json_annotation/json_annotation.dart';

part 'req_add_rating_model.g.dart';

@JsonSerializable()
class ReqAddRatingModel {
  @JsonKey(name: "product_id")
  final int productId;
  final String comment;
  final int rating;
  ReqAddRatingModel({
    required this.productId,
    required this.comment,
    required this.rating,
  });
  factory ReqAddRatingModel.fromJson(Map<String, dynamic> json) =>
      _$ReqAddRatingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqAddRatingModelToJson(this);
}
