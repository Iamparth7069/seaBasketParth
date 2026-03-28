import 'package:flutter/material.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/enum_utils.dart';
import 'package:seabasket/src/controllers/product_controller.dart';
import 'package:seabasket/src/models/category/category_model.dart';
import 'package:seabasket/src/models/product.dart';
import 'package:seabasket/src/models/product/product_model.dart';
import 'package:seabasket/src/models/response/res_product_detail_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  ResProductDetailModel? _selectedProduct;
  ResProductDetailModel? get selectedProduct => _selectedProduct;

  RangeValues _priceRange = const RangeValues(0, 2000);
  RangeValues get priceRange => _priceRange;

  int _selectedSortIndex = 0;
  int get selectedSortIndex => _selectedSortIndex;

  double? _selectedRating;
  double? get selectedRating => _selectedRating;

  int _selectedSizeIndex = 0;
  int get selectedSizeIndex => _selectedSizeIndex;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  Set<int> _selectedDiscounts = {};
  Set<int> get selectedDiscounts => _selectedDiscounts;

  int? _selectedCategoryId;
  int? get selectedCategoryId => _selectedCategoryId;

  RangeValues _tempPriceRange = const RangeValues(0, 2000);
  RangeValues get tempPriceRange => _tempPriceRange;

  int _tempSortIndex = 0;
  int get tempSortIndex => _tempSortIndex;

  double? _tempRating;
  double? get tempRating => _tempRating;

  Set<int> _tempDiscounts = {};
  Set<int> get tempDiscounts => _tempDiscounts;

  void setProducts(List<ProductModel> products) {
    _products = products;
    notifyListeners();
  }

  void setSelectedProduct(ResProductDetailModel detail) {
    _selectedProduct = detail;
    notifyListeners();
  }

  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }

  void openFilterSheet() {
    _tempPriceRange = _priceRange;
    _tempSortIndex = _selectedSortIndex;
    _tempRating = _selectedRating;
    _tempDiscounts = {..._selectedDiscounts};
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void setSelectedCategory(int? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void selectSize(int index) {
    _selectedSizeIndex = index;
    notifyListeners();
  }

  void selectSort(int index) {
    _tempSortIndex = index;
    notifyListeners();
  }

  void updatePriceRange(RangeValues values) {
    _tempPriceRange = values;
    notifyListeners();
  }

  void selectRating(double? rating) {
    _tempRating = _tempRating == rating ? null : rating;
    notifyListeners();
  }

  void toggleDiscount(int discount) {
    if (_tempDiscounts.contains(discount)) {
      _tempDiscounts.remove(discount);
    } else {
      _tempDiscounts.add(discount);
    }
    notifyListeners();
  }

  void applyFilters() {
    _priceRange = tempPriceRange;
    _selectedRating = _tempRating;
    _selectedDiscounts = {..._tempDiscounts};
    _selectedSortIndex = tempSortIndex;
    notifyListeners();
  }

  void clearFilters() {
    _priceRange = const RangeValues(0, 2000);
    _selectedRating = null;
    _selectedDiscounts = {};
    _selectedSortIndex = 0;
    _tempPriceRange = const RangeValues(0, 2000);
    _tempRating = null;
    _tempDiscounts = {};
    _tempSortIndex = 0;
    notifyListeners();
  }
}
