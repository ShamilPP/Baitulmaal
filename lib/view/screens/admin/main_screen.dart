import 'package:baitulmaal/view/screens/admin/transactions_screen.dart';
import 'package:baitulmaal/view_model/navigation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors.dart';
import 'analytics_screen.dart';
import 'home_screen.dart';
import 'request_screen.dart';
import 'users_list_screen.dart';

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({Key? key}) : super(key: key);
  final List<Widget> pages = const [
    AdminTransactionScreen(),
    UsersScreen(),
    AdminHomeScreen(),
    RequestScreen(),
    AnalyticsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (ctx, provider, child) {
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            body: pages[provider.currentBottomNavigator],
            bottomNavigationBar: const MyBottomNavigation(),
          ),
        );
      },
    );
  }
}

class MyBottomNavigation extends StatelessWidget {
  const MyBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (ctx, provider, child) {
        return BottomNavigationBar(
          currentIndex: provider.currentBottomNavigator,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_outlined),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.request_page_outlined),
              label: 'Requests',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              label: 'Analytics',
            ),
          ],
          onTap: (newIndex) {
            provider.setCurrentBottomNavigator(newIndex);
          },
        );
      },
    );
  }
}
