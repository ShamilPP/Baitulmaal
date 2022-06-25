import 'package:flutter/material.dart';
import 'package:baitulmaal/utils/colors.dart';
import 'package:baitulmaal/view_model/navigation_view_model.dart';
import 'package:provider/provider.dart';

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
              icon: Icon(Icons.notifications_outlined),
              label: 'Notifications',
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
