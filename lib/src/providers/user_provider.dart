import 'package:flutter/material.dart';
import 'package:seabasket/src/base/utils/constants/preference_key_constant.dart';
import 'package:seabasket/src/base/utils/preference_utils.dart';
import 'package:seabasket/src/models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => getBool(prefkeyIsLogin);
  bool get isOtpVerified => getBool(prefkeyIsOtpVerified);

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void updateUser({String? phoneNumber, String? address}) {
    if (_currentUser == null) return;
    _currentUser = User(
      email: _currentUser!.email,
      username: _currentUser!.username,
      phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
      address: address ?? _currentUser!.address,
    );
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
