import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int? discountPercent;
  final double averageRating;
  final List<String> images;
  final List<String> availableSizes;
  final String categoryId;
  bool isFavourite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPercent,
    required this.averageRating,
    required this.images,
    required this.availableSizes,
    required this.categoryId,
    this.isFavourite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
