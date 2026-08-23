import 'package:flutter/material.dart';
import 'package:snap_ecommerce_app/views/buttonNav/navPages/cart_page.dart';
import 'package:snap_ecommerce_app/views/buttonNav/navPages/defaultPage/default_page.dart';
import 'package:snap_ecommerce_app/views/buttonNav/navPages/order/orders_page.dart';
import 'package:snap_ecommerce_app/views/buttonNav/navPages/profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int chosenIndex = 0;

  final List<Widget> navPages = const [
    DefaultPage(),
    OrdersPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: chosenIndex, children: navPages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: chosenIndex,
        onDestinationSelected: (index) => setState(() => chosenIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag_rounded),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
