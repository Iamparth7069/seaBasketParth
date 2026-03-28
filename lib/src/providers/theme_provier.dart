import 'package:flutter/foundation.dart';
import 'package:seabasket/src/base/utils/constants/preference_key_constant.dart';
import 'package:seabasket/src/base/utils/preference_utils.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode {
    return _isDarkMode;
  }

  void changeTheme({required bool value}) async {
    await setBool(prefkeyIsDarkMode, value);
    notifyListeners();
  }

  bool getTheme() {
    _isDarkMode = getBool(prefkeyIsDarkMode);
    return _isDarkMode;
  }

  void clearAllData() {
    _isDarkMode = false;
    notifyListeners();
  }
}
