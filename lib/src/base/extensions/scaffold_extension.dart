import 'package:flutter/material.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';

extension ScaffoldExtension on Widget {
  Scaffold authContainerScaffold({
    required BuildContext context,
    PreferredSizeWidget? appBar,
  }) {
    return Scaffold(
      extendBody: true,
      appBar: appBar,
      backgroundColor: primaryScaffold,
      body: SafeArea(
        child: this,
      ),
    );
  }

  Scaffold commonScaffold({
    required BuildContext context,
    required String title,
    Widget? leading,
    List<Widget>? actions,
    bool? centerTitle,
    Widget? bottomNavigationBar,
  }) {
    return Scaffold(
      extendBody: true,
      backgroundColor: primaryScaffold,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: centerTitle ?? false,
        leading: leading,
        title: Text(
          title,
          style: const TextStyle(
              fontSize: fontSize24,
              fontWeight: fontWeightSemiBold,
              color: primaryColor),
        ),
        actions: actions,
      ),
      body: SafeArea(
        child: this,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Dialog dialogContainer({double height = 350}) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 20.0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        height: height,
        padding: const EdgeInsets.all(20.0),
        child: this,
      ),
    );
  }
}
