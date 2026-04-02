import 'package:flutter/material.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';

extension ScaffoldExtension on Widget {
  Scaffold authContainerScaffold({
    required BuildContext context,
    bool showBackButton = false,
    List<Widget>? actions,
    String? title,
  }) {
    return Scaffold(
      appBar: AppBar(
          title: title != null ? Text(title) : null,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: showBackButton
              ? IconButton(
                  onPressed: locator<NavigationUtils>().pop,
                  icon: const Icon(Icons.arrow_back, color: primaryColor),
                )
              : null,
          actions: actions),
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
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 20.0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: this,
      ),
    );
  }
}
