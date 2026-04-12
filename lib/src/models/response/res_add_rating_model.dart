import 'package:json_annotation/json_annotation.dart';

part 'res_add_rating_model.g.dart';

@JsonSerializable()
class ResAddRatingModel {
  final int? rating;
  final String? comment;
  @JsonKey(name: 'product_average')
  final double? productAverage;

  ResAddRatingModel({this.rating, this.comment, this.productAverage});
  factory ResAddRatingModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return _$ResAddRatingModelFromJson(data as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() => _$ResAddRatingModelToJson(this);
}
