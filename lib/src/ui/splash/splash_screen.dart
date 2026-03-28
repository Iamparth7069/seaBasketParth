import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import 'package:seabasket/src/base/utils/constants/image_constant.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/providers/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplash();
  }

  void _startSplash() {
    Timer(
      const Duration(seconds: 3),
      _checkLoginStatus,
    );
  }

  void _checkLoginStatus() {
    final userPorvider = context.read<UserProvider>();
    if (userPorvider.isLoggedIn) {
      locator<NavigationUtils>().pushReplacement(routeBase);
    } else {
      locator<NavigationUtils>().pushReplacement(routeLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset(
            imgAppLogo,
            height: context.getHeight(0.6),
            width: context.getWidth(0.6),
          ),
        ),
      ),
    );
  }
}
