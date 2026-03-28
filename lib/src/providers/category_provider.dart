import 'package:flutter/material.dart';
import 'package:seabasket/src/models/category/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  int _selectedCategoryIndex = 0;
  int get selectedCategoryIndex => _selectedCategoryIndex;

  void setCategories(List<CategoryModel> categories) {
    _categories = categories;
    notifyListeners();
  }

  void selectCategory(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }
}
