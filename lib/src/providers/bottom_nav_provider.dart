import 'package:flutter/material.dart';

class BottomNavProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  bool _fromHomeSearch = false;
  bool get fromHomeSearch => _fromHomeSearch;

  void changeTab(int index, {bool fromHomeSearch = false}) {
    _selectedIndex = index;
    if (index == 1) {
      _fromHomeSearch = fromHomeSearch;
    } else {
      _fromHomeSearch = false;
    }

    notifyListeners();
  }
}
