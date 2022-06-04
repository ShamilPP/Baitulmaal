import 'package:flutter/material.dart';
import 'package:meekath/view_model/admin_view_model.dart';
import 'package:provider/provider.dart';

import '../../widgets/analytics_container.dart';
import '../../widgets/users_list.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<AdminProvider>(builder: (ctx, provider, child) {
            return AnalyticsContainer(
              topLeftAmount: provider.adminOverview.pendingUsers,
              topLeftText: "Pending users",
              topRightAmount: provider.adminOverview.totalUsers,
              topRightText: "Total users",
              bottomLeftAmount: provider.adminOverview.pendingAmount,
              bottomLeftText: "Pending amount",
              bottomRightAmount: provider.adminOverview.totalAmount,
              bottomRightText: "Total amount",
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Users list",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
              ),
              NotifyIcon(),
            ],
          ),
          Consumer<AdminProvider>(builder: (ctx, provider, child) {
            return UsersList(
              users: provider.users,
            );
          }),
        ],
      ),
    );
  }
}

class NotifyIcon extends StatelessWidget {
  const NotifyIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            const Icon(
              Icons.notifications_outlined,
              color: Colors.orange,
              size: 35,
            ),
            Consumer<AdminProvider>(builder: (ctx, provider, child) {
              return Visibility(
                visible: provider.paymentNotVerifiedList.isNotEmpty,
                child: Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      onTap: () {
        Provider.of<AdminProvider>(context).setCurrentBottomNavigator(3);
      },
    );
  }
}
