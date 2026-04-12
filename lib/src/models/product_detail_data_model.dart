import 'package:json_annotation/json_annotation.dart';
import 'package:seabasket/src/models/product/product_model.dart';

part 'product_detail_data_model.g.dart';

@JsonSerializable()
class ProductDetailDataModel {
  final ProductModel? product;
  @JsonKey(name: 'available_sizes')
  final List<String>? availableSizes;

  ProductDetailDataModel({
    this.product,
    this.availableSizes,
  });

  factory ProductDetailDataModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailDataModelToJson(this);
}
