import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final int? id;
  final String? name;
  final String? description;
  final double? price;
  final double? discountedPrice;
  final double? discountPercentage;
  final double? averageRating;
  final int? categoryId;
  final String? imageUrl;
  final bool? isTrending;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? small_size_stock;
  final int? medium_size_stock;
  final int? large_size_stock;
  final int? extra_large_size_stock;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.discountedPrice,
    this.discountPercentage,
    this.averageRating,
    this.categoryId,
    this.imageUrl,
    this.isTrending,
    this.createdAt,
    this.updatedAt,
    this.small_size_stock,
    this.medium_size_stock,
    this.large_size_stock,
    this.extra_large_size_stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
