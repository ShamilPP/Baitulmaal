import 'package:flutter/material.dart';
import 'package:meekath/view/screens/admin/transactions_screen.dart';
import 'package:meekath/view/widgets/my_bottom_navigation.dart';
import 'package:meekath/view_model/navigation_view_model.dart';
import 'package:provider/provider.dart';

import 'analytics_screen.dart';
import 'home_screen.dart';
import 'notification_screen.dart';
import 'users_list_screen.dart';

class AdminMainScreen extends StatelessWidget {
  AdminMainScreen({Key? key}) : super(key: key);
  final List<Widget> pages = [
    const AdminTransactionScreen(),
    UsersScreen(),
    const AdminHomeScreen(),
    const NotificationScreen(),
    const AnalyticsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(builder: (ctx, provider, child) {
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          body: pages[provider.currentBottomNavigator],
          bottomNavigationBar: const MyBottomNavigation(),
        ),
      );
    });
  }
}
