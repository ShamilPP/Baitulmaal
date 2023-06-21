import 'package:baitulmaal/view/animations/slide_animation.dart';
import 'package:baitulmaal/view_model/admin_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/analytics.dart';
import '../../../model/user.dart';
import '../../widgets/general/analytics_card.dart';
import '../../widgets/general/loading_widget.dart';
import '../../widgets/general/users_list.dart';
import '../../widgets/screen/admin/home/admin_popup_menu.dart';
import '../../widgets/screen/admin/home/pay_for_user_dialog.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<AdminProvider>(builder: (ctx, provider, child) {
                Analytics? adminAnalytics = provider.analytics;
                if (adminAnalytics == null) {
                  return const Center(
                    child: Padding(padding: EdgeInsets.all(90), child: LoadingWidget()),
                  );
                } else {
                  return AnalyticsCard(
                    percentage: 1 - (adminAnalytics.pendingAmount / adminAnalytics.totalAmount),
                    topLeftAmount: '${provider.users.length}',
                    topLeftText: 'Total users',
                    topRightAmount: '₹ ${adminAnalytics.yearlyAmount}',
                    topRightText: 'Total amount',
                    bottomLeftAmount: '₹ ${adminAnalytics.totalAmount}',
                    bottomLeftText: 'Total amount due',
                    bottomRightAmount: '₹ ${adminAnalytics.pendingAmount}',
                    bottomRightText: 'Pending amount',
                  );
                }
              }),

              // text(Users List) and popupmenu
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SlideAnimation(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Users',
                        style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SlideAnimation(
                    delay: 400,
                    child: AdminPopupMenu(),
                  ),
                ],
              ),

              // Users list
              Consumer<AdminProvider>(builder: (ctx, provider, child) {
                return UsersList(
                  users: provider.users,
                );
              }),
            ],
          ),

          // Floating action button
          Positioned(
            right: 20,
            bottom: 20,
            child: SlideAnimation(
              child: FloatingActionButton(
                child: const Icon(Icons.currency_rupee),
                onPressed: () {
                  List<User> users = Provider.of<AdminProvider>(context, listen: false).users;
                  showDialog(context: context, builder: (ctx) => PayForUserDialog(users: users));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
