import 'package:seabasket/src/apis/api_service.dart';
import 'package:seabasket/src/apis/apimanagers/auth_api_manager.dart';
import 'package:seabasket/src/apis/apimanagers/cart_api_manager.dart';
import 'package:seabasket/src/apis/apimanagers/category_api_manager.dart';
import 'package:seabasket/src/apis/apimanagers/checkout_api_manager.dart';
import 'package:seabasket/src/apis/apimanagers/order_api_manager.dart';
import 'package:seabasket/src/apis/apimanagers/product_api_manager.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/controllers/auth/auth_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:seabasket/src/controllers/category_controller.dart';
import 'package:seabasket/src/controllers/cart_controller.dart';
import 'package:seabasket/src/controllers/checkout_controller.dart';
import 'package:seabasket/src/controllers/product_controller.dart';
import 'package:seabasket/src/controllers/order_controller.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Common
  locator.registerSingleton<NavigationUtils>(NavigationUtils());
  locator.registerSingleton<ApiService>(ApiService());

  // API Managers
  locator.registerSingleton<AuthApiManager>(AuthApiManager());
  locator.registerSingleton<CategoryApiManager>(CategoryApiManager());
  locator.registerSingleton<ProductApiManager>(ProductApiManager());
  locator.registerSingleton<CartApiManager>(CartApiManager());
  locator.registerSingleton<CheckoutApiManager>(CheckoutApiManager());
  locator.registerSingleton<OrderApiManager>(OrderApiManager());

  // Controller
  locator.registerSingleton<AuthController>(AuthController());
  locator.registerSingleton<CategoryController>(CategoryController());
  locator.registerSingleton<ProductController>(ProductController());
  locator.registerSingleton<CartController>(CartController());
  locator.registerSingleton<CheckoutController>(CheckoutController());
  locator.registerSingleton<OrderController>(OrderController());
}
