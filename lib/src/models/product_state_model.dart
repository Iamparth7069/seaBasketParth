import 'package:flutter/material.dart';

class ProductStateModel {
  int page;
  int pageSize;
  bool hasMore;
  bool isLoading;
  RangeValues priceRange;
  RangeValues tempPriceRange;

  int selectedSortIndex;
  int tempSortIndex;

  double? selectedRating;
  double? tempRating;

  Set<int> selectedDiscounts;
  Set<int> tempDiscounts;

  int selectedSizeIndex;
  bool isAddingToCart;

  ProductStateModel({
    this.page = 1,
    this.pageSize = 10,
    this.hasMore = true,
    this.isLoading = false,
    this.priceRange = const RangeValues(0, 2000),
    this.tempPriceRange = const RangeValues(0, 2000),
    this.selectedSortIndex = 0,
    this.tempSortIndex = 0,
    this.selectedRating,
    this.tempRating,
    Set<int>? selectedDiscounts,
    Set<int>? tempDiscounts,
    this.selectedSizeIndex = 0,
    this.isAddingToCart = false,
  })  : selectedDiscounts = selectedDiscounts ?? {},
        tempDiscounts = tempDiscounts ?? {};
}
