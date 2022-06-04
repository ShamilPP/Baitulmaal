import 'package:flutter/material.dart';
import 'package:meekath/utils/colors.dart';
import 'package:meekath/view_model/admin_view_model.dart';
import 'package:provider/provider.dart';

class MyBottomNavigation extends StatelessWidget {
  const MyBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (ctx, provider, child) {
        return BottomNavigationBar(
          currentIndex: provider.currentBottomNavigator,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_outlined),
              label: "Transactions",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: "Users",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              label: "Notifications",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              label: "Analytics",
            ),
          ],
          onTap: (newIndex) {
            // Update data if payment verified
            // 3 == Notification screen
            if (provider.currentBottomNavigator == 3) {
              updateData(context);
            }

            provider.setCurrentBottomNavigator(newIndex);
          },
        );
      },
    );
  }

  void updateData(BuildContext context) async {
    AdminProvider provider = Provider.of<AdminProvider>(context, listen: false);
    int initialLength = provider.initialLength;
    int newLength = provider.paymentNotVerifiedList.length;
    if (initialLength != newLength) {
      provider.showMyDialog(context, "Updating...");
      await provider.initData(true);
      Navigator.pop(context);
    }
  }
}
