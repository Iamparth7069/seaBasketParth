import 'package:flutter/material.dart';
import 'package:seabasket/src/base/utils/constants/dic_params.dart';
import 'package:seabasket/src/ui/auth/forgot_password_screen.dart';
import 'package:seabasket/src/ui//home/base_screen.dart';
import 'package:seabasket/src/ui/auth/login_screen.dart';
import 'package:seabasket/src/ui/auth/otpverify_screen.dart';
import 'package:seabasket/src/ui/auth/register_screen.dart';
import 'package:seabasket/src/ui/auth/reset_password_screen.dart';
import 'package:seabasket/src/ui/cart_screen.dart';
import 'package:seabasket/src/ui/checkout_screen.dart';
import 'package:seabasket/src/ui/home/search_screen.dart';
import 'package:seabasket/src/ui/order_detail_screen.dart';
import 'package:seabasket/src/ui/order_history.dart';
import 'package:seabasket/src/ui/order_status_screen.dart';
import 'package:seabasket/src/ui/product_detail_screen.dart';
import 'package:seabasket/src/ui/profile_screen.dart';
import 'package:seabasket/src/ui/splash/splash_screen.dart';
import 'constants/navigation_route_constants.dart';

class NavigationUtils {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get getCurrentContext {
    return _navigatorKey.currentContext!;
  }

  GlobalKey<NavigatorState> get navigatorKey {
    return _navigatorKey;
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case routeSplash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );
      case routeLogin:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
      case routeRegister:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RegisterScreen(),
        );
      case routeForgotPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ForgotPasswordScreen(),
        );
      case routeOtpVerify:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => OtpverifyScreen(
            email: args?[paramEmail],
            isLoginScreen: args?[paramisLoginScreen],
          ),
        );
      case routeResetPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ResetPasswordScreen(),
        );
      case routeBase:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const BaseScreen(),
        );
      case routeSearch:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SearchScreen(),
        );
      case routeProductDetails:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ProductDetailScreen(
            productId: args?[paramProductId],
          ),
        );
      case routeCart:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CartScreen(),
        );
      case routeProfile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProfileScreen(),
        );
      case routeCheckout:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CheckoutScreen(),
        );
      case routeOrderDetail:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OrderDetailScreen(),
        );
      case routeOrderHistory:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => OrderHistory(
            orderId: args?[paramOrderId],
          ),
        );
      case routeOrderStatus:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OrderStatusScreen(),
        );

      default:
        return _errorRoute(" Comming soon...");
    }
  }

  Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text(message)));
    });
  }

  void pushReplacement(String routeName, {Object? arguments}) {
    _navigatorKey.currentState
        ?.pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic>? push(String routeName, {Object? arguments}) {
    return _navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

  void pop({dynamic args}) {
    _navigatorKey.currentState?.pop(args);
  }

  Future<dynamic>? pushAndRemoveUntil(String routeName, {Object? arguments}) {
    return _navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName, (route) => false,
        arguments: arguments);
  }
}