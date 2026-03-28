import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/dialog_utils.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/controllers/auth/auth_controller.dart';
import 'package:seabasket/src/providers/bottom_nav_provider.dart';
import 'package:seabasket/src/providers/checkout_provider.dart';
import 'package:seabasket/src/providers/order_provider.dart';
import 'package:seabasket/src/providers/user_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _menuTile(
          icon: Icons.inventory_2_outlined,
          title: "My orders",
          onTap: () {
            locator<NavigationUtils>().push(routeOrderDetail);
          },
        ),
        const Divider(
          thickness: 6,
          color: secondaryDividerColor,
        ),
        _menuTile(
            icon: Icons.person_outlined,
            title: "My details",
            onTap: () {
              locator<NavigationUtils>().push(routeProfile);
            }),
        const Divider(
          thickness: 1,
          color: secondaryDividerColor,
          indent: 30,
          endIndent: 30,
        ),
        Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return userProvider.isLoggedIn
                ? ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: logoutButtonColor,
                    ),
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        color: logoutButtonColor,
                        fontSize: fontSize16,
                        fontWeight: fontWeightMedium,
                      ),
                    ),
                    onTap: _showLogoutDialog,
                  )
                : const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: fontSize16,
          fontWeight: fontWeightMedium,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showLogoutDialog() {
    showAlertDialog(
        message: Localization.of().msgLogoutConfirm,
        okButtonTitle: Localization.of().yes,
        okButtonAction: () {
          locator<NavigationUtils>().pop();
          // context.read<OrderProvider>().clearOrders();
          context.read<CheckoutProvider>().clearCardDetails();
          context.read<AuthController>().logout(context);
          locator<NavigationUtils>().pushAndRemoveUntil(routeBase);
          context.read<BottomNavProvider>().changeTab(0);
        },
        isCancelEnable: true);
  }
}
