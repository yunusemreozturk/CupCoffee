import 'package:cupcoffee/src/config/theme.dart';
import 'package:cupcoffee/src/view/home_page.dart';
import 'package:cupcoffee/src/view/map_page.dart';
import 'package:cupcoffee/src/view/my_favorites_page.dart';
import 'package:cupcoffee/src/view/shoping_page.dart';
import 'package:cupcoffee/src/view/user_info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../config/custom_icons_icons.dart';

class BottomNavigator extends StatelessWidget {
  BottomNavigator({Key? key}) : super(key: key);

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  //todo: theme
  Color activeNavigatorColor = const Color(0xff314D45);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: const NavBarDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(13),
          topRight: Radius.circular(13),
          bottomRight: Radius.circular(23),
          bottomLeft: Radius.circular(23),
        ),
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      ShopingPage(),
      MapPage(),
      MyFavoritesPage(),
      UserInfoPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CustomIcons.home),
        activeColorPrimary: themeData.iconTheme.color!,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CustomIcons.shopping_bag),
        activeColorPrimary: themeData.iconTheme.color!,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CustomIcons.map_pin),
        activeColorPrimary: themeData.iconTheme.color!,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CustomIcons.heart),
        activeColorPrimary: themeData.iconTheme.color!,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CustomIcons.user),
        activeColorPrimary: themeData.iconTheme.color!,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}
