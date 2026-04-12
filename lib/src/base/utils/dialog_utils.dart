import 'dart:io';

import 'package:flutter/material.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/widgets/customdialogs/cupertino_error_dialog.dart';
import 'package:seabasket/src/widgets/customdialogs/material_error_dialog.dart';

void showAlertDialog({
  Widget? child,
  String? message,
  String? okButtonTitle,
  Function()? okButtonAction,
  bool isCancelEnable = true,
}) {
  showDialog(
    context: locator<NavigationUtils>().getCurrentContext,
    barrierDismissible: isCancelEnable,
    builder: (dialogContext) {
      return child != null
          ? Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: child,
            )
          : Platform.isIOS
              ? CupertinoErrorDialog(
                  message: message ?? '',
                  okTitle: okButtonTitle,
                  okFunction: okButtonAction,
                  isCancelEnable: isCancelEnable,
                )
              : MaterialErrorDialog(
                  message: message ?? '',
                  okTitle: okButtonTitle,
                  okFunction: okButtonAction,
                  isCancelEnable: isCancelEnable,
                );
    },
  );
}
