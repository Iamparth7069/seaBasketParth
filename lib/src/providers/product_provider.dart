import 'package:flutter/material.dart';
import 'package:seabasket/src/models/product/product_model.dart';
import 'package:seabasket/src/models/product_state_model.dart';
import 'package:seabasket/src/models/response/res_product_detail_model.dart';

class ProductProvider extends ChangeNotifier {
  ProductStateModel _state = ProductStateModel();

  int get page => _state.page;
  int get pageSize => _state.pageSize;
  bool get hasMore => _state.hasMore;
  bool get isLoading => _state.isLoading;
  RangeValues get priceRange => _state.priceRange;
  RangeValues get tempPriceRange => _state.tempPriceRange;
  int get selectedSortIndex => _state.selectedSortIndex;
  int get tempSortIndex => _state.tempSortIndex;
  double? get selectedRating => _state.selectedRating;
  double? get tempRating => _state.tempRating;
  Set<int> get selectedDiscounts => _state.selectedDiscounts;
  Set<int> get tempDiscounts => _state.tempDiscounts;
  int get selectedSizeIndex => _state.selectedSizeIndex;
  bool get isAddingToCart => _state.isAddingToCart;

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  ResProductDetailModel? _selectedProduct;
  ResProductDetailModel? get selectedProduct => _selectedProduct;
  String _searchQuery = "";
  String get searchQuery => _searchQuery;
  int? _selectedCategoryId;
  int? get selectedCategoryId => _selectedCategoryId;

  void resetPage() {
    _state.page = 1;
    _state.hasMore = true;
    notifyListeners();
  }

  void incrementPage() {
    _state.page++;
    notifyListeners();
  }

  void setLoading(bool value) {
    _state.isLoading = value;
    notifyListeners();
  }

  void setProducts(List<ProductModel> products, {bool append = false}) {
    if (append) {
      _products.addAll(products);
    } else {
      _products = products;
    }
    notifyListeners();
  }

  void updateHasMore(bool value) {
    _state.hasMore = value;
    notifyListeners();
  }

  void clearProducts() {
    _products.clear();
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
    _state.tempPriceRange = _state.priceRange;
    _state.tempSortIndex = _state.selectedSortIndex;
    _state.tempRating = _state.selectedRating;
    _state.tempDiscounts = {..._state.selectedDiscounts};
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
    _state.selectedSizeIndex = index;
    notifyListeners();
  }

  void selectSort(int index) {
    _state.tempSortIndex = index;
    notifyListeners();
  }

  void updatePriceRange(RangeValues values) {
    _state.tempPriceRange = values;
    notifyListeners();
  }

  void selectRating(double? rating) {
    _state.tempRating = _state.tempRating == rating ? null : rating;
    notifyListeners();
  }

  void setAddingToCart(bool value) {
    _state.isAddingToCart = value;
    notifyListeners();
  }

  void toggleDiscount(int discount) {
    if (_state.tempDiscounts.contains(discount)) {
      _state.tempDiscounts.remove(discount);
    } else {
      _state.tempDiscounts.add(discount);
    }
    notifyListeners();
  }

  void applyFilters() {
    _state.priceRange = _state.tempPriceRange;
    _state.selectedRating = _state.tempRating;
    _state.selectedDiscounts = {..._state.tempDiscounts};
    _state.selectedSortIndex = _state.tempSortIndex;
    notifyListeners();
  }

  void clearFilters() {
    _state.priceRange = const RangeValues(0, 2000);
    _state.selectedRating = null;
    _state.selectedDiscounts = {};
    _state.selectedSortIndex = 0;
    _state.tempPriceRange = const RangeValues(0, 2000);
    _state.tempRating = null;
    _state.tempDiscounts = {};
    _state.tempSortIndex = 0;
    notifyListeners();
  }
}
