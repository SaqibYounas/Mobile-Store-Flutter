import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/config/app_routes.dart';
import 'package:e_commerce_flutter/src/core/app_toast.dart';
import 'package:e_commerce_flutter/src/core/services/session_service.dart';
import 'package:e_commerce_flutter/src/model/bottom_tab.dart';
import 'package:e_commerce_flutter/src/view/animation/page_transition_switcher_wrapper.dart';
import 'package:e_commerce_flutter/src/view/screen/cart_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/favorite_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/orders_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/product_list_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/profile_screen.dart';
import 'package:e_commerce_flutter/src/view/widget/home/modern_bottom_bar.dart';

/// Customer shell — holds the five-tab bottom navigation and swaps the
/// body screen as the user moves between tabs.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const _screens = <Widget>[
    ProductListScreen(),
    FavoriteScreen(),
    CartScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  static const _tabs = <BottomTab>[
    BottomTab(
      label: 'Shop',
      icon: Icons.storefront_outlined,
      activeIcon: Icons.storefront_rounded,
    ),
    BottomTab(
      label: 'Wishlist',
      icon: Icons.favorite_border_rounded,
      activeIcon: Icons.favorite_rounded,
    ),
    BottomTab(
      label: 'Cart',
      icon: Icons.shopping_bag_outlined,
      activeIcon: Icons.shopping_bag_rounded,
    ),
    BottomTab(
      label: 'Orders',
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long_rounded,
    ),
    BottomTab(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  static const _cartTabIndex = 2;

  void _onTabChanged(int index) {
    // Cart tab is gated behind authentication. Browsing/wishlist/orders
    // remain open so users can window-shop without an account.
    if (index == _cartTabIndex && !SessionService.isLoggedIn) {
      AppToast.info('Login Required', 'Sign in to view your cart');
      Get.toNamed(AppRoutes.auth);
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageTransitionSwitcherWrapper(child: _screens[_currentIndex]),
      bottomNavigationBar: ModernBottomBar(
        tabs: _tabs,
        currentIndex: _currentIndex,
        onChanged: _onTabChanged,
      ),
    );
  }
}
