import 'package:json_annotation/json_annotation.dart';
import 'package:seabasket/src/models/product/product_model.dart';

part 'res_product_detail_model.g.dart';

@JsonSerializable()
class ResProductDetailModel {
  final ProductModel? product;
  final List<String?> available_sizes;

  ResProductDetailModel({
    this.product,
    this.available_sizes = const [],
  });

  factory ResProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ResProductDetailModel(
      product: json['data']?['product'] != null
          ? ProductModel.fromJson(
              json['data']['product'] as Map<String, dynamic>)
          : null,
      available_sizes: (json['data']?['available_sizes'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
