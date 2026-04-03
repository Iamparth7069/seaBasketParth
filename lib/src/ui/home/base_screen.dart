import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/scaffold_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/providers/bottom_nav_provider.dart';
import 'package:seabasket/src/providers/user_provider.dart';
import 'package:seabasket/src/ui//home/home_screen.dart';
import 'package:seabasket/src/ui//home/saved_screen.dart';
import 'package:seabasket/src/ui//home/search_screen.dart';
import 'package:seabasket/src/ui/account_screen.dart';
import 'package:seabasket/src/ui/cart_screen.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const SearchScreen(),
      const CartScreen(),
      const AccountScreen(),
    ];

    final titles = [
      Localization.of().discoverText,
      Localization.of().searchText,
      Localization.of().cartText,
      Localization.of().yourDetailsText,
    ];

    return Consumer2<BottomNavProvider, UserProvider>(
      builder: (context, provider, userProvider, _) {
        final index = provider.selectedIndex;
        return screens[index].commonScaffold(
          context: context,
          title: titles[index],
          centerTitle: index != 0 ? true : false,
          leading: ((index == 1 && provider.fromHomeSearch) ||
                  (index == 3 && !userProvider.isLoggedIn))
              ? IconButton(
                  onPressed: () {
                    provider.changeTab(0);
                  },
                  icon: const Icon(Icons.arrow_back),
                )
              : null,
          actions: index == 1
              ? [
                  if (!userProvider.isLoggedIn)
                    IconButton(
                      onPressed: () {
                        locator<NavigationUtils>().push(routeLogin);
                      },
                      icon: const Icon(Icons.login),
                    )
                ]
              : null,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: provider.selectedIndex,
            onTap: (index) {
              provider.changeTab(index, fromHomeSearch: false);
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  label: Localization.of().homeText),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.search),
                  label: Localization.of().searchText),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: Localization.of().cartText),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline),
                  label: Localization.of().accountText),
            ],
          ),
        );
      },
    );
  }
}
