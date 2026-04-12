import 'package:json_annotation/json_annotation.dart';
import 'package:seabasket/src/models/product/product_model.dart';
import 'package:seabasket/src/models/product_detail_data_model.dart';

part 'res_product_detail_model.g.dart';

@JsonSerializable()
class ResProductDetailModel {
  final ProductDetailDataModel? data;
  ResProductDetailModel({this.data});

  factory ResProductDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ResProductDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResProductDetailModelToJson(this);
}
