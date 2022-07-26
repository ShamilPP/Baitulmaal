import 'package:baitulmaal/view/animations/slide_in_widget.dart';
import 'package:baitulmaal/view/screens/pay_screen.dart';
import 'package:baitulmaal/view_model/admin_view_model.dart';
import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../../../model/analytics_model.dart';
import '../../../model/user_model.dart';
import '../../widgets/analytics_card.dart';
import '../../widgets/users_list.dart';

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
                AnalyticsModel adminAnalytics = provider.analytics;
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
              }),

              // Users list
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
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
                  List<UserModel> users = Provider.of<AdminProvider>(context, listen: false).users;
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

class PayForUserDialog extends StatelessWidget {
  final List<UserModel> users;

  PayForUserDialog({Key? key, required this.users}) : super(key: key);

  final ValueNotifier<List<UserModel>> searchedUsers = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    searchedUsers.value = users;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.grey.shade200,
      child: SizedBox(
        width: 300,
        height: 400,
        child: Column(
          children: [
            // AppBar
            Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
              child: Row(
                children: const [
                  CloseButton(),
                  SizedBox(width: 10),
                  Text(
                    'Pay the user',
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),

            // Search TextField
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                textAlign: TextAlign.start,
                onChanged: onChanged,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),

            // Users List
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: searchedUsers,
                builder: (context, List<UserModel> users, _) {
                  return ListView.separated(
                    itemCount: searchedUsers.value.length,
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        title: Text(searchedUsers.value[index].name),
                        subtitle: Text('₹ ${searchedUsers.value[index].monthlyPayment}'),
                        onTap: () {
                          // Go to pay screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PayScreen(
                                user: searchedUsers.value[index],
                                isAdmin: true,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (ctx, index) {
                      return const Divider(thickness: 1, height: 0);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onChanged(String searchedName) {
    List<UserModel> _users = [];
    for (var user in users) {
      if (user.name.toLowerCase().contains(searchedName.toLowerCase())) {
        _users.add(user);
      }
    }
    searchedUsers.value = _users;
  }
}

class AdminPopupMenu extends StatelessWidget {
  const AdminPopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> currentMeekath = ValueNotifier(DateTime.now().year);
    var provider = Provider.of<PaymentProvider>(context, listen: false);
    var meekathList = provider.getMeekathList();
    currentMeekath.value = provider.meekath;

    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return {'Meekath'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
      onSelected: (value) {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Select meekath"),
              content: ValueListenableBuilder<int>(
                valueListenable: currentMeekath,
                builder: (ctx, meekath, child) {
                  return NumberPicker(
                      value: meekath,
                      minValue: meekathList.first,
                      maxValue: meekathList.last,
                      decoration: BoxDecoration(
                          border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                        bottom: BorderSide(color: Colors.grey.shade300),
                      )),
                      onChanged: (value) => currentMeekath.value = value);
                },
              ),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                ),
                ElevatedButton(
                  child: const Text("Select"),
                  onPressed: () async {
                    // Close meekath selecting dialog
                    Navigator.pop(ctx);
                    // Then starting loading dialog and update values
                    var adminProvider = Provider.of<AdminProvider>(context, listen: false);
                    adminProvider.showLoadingDialog(context, 'Updating...');
                    provider.setMeekath(currentMeekath.value);
                    await adminProvider.loadDataFromFirebase(context);
                    // After close loading dialog
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
