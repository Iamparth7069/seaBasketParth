import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';

import 'constants/color_constant.dart';
import 'navigation_utils.dart';

class ProgressDialogUtils {
  ProgressDialogUtils._();
  static bool _isLoading = false;
  static void dismissProgressDialog() {
    if (!_isLoading) return;
    final context = locator<NavigationUtils>().getCurrentContext;
    if (Navigator.canPop(context)) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    _isLoading = false;
  }

  static void showProgressDialog() {
    if (_isLoading) return;
    _isLoading = true;

    final context = locator<NavigationUtils>().getCurrentContext;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withAlpha(70),
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 40,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
