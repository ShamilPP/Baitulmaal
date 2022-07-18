import 'package:baitulmaal/model/user_model.dart';
import 'package:baitulmaal/utils/colors.dart';
import 'package:baitulmaal/view/screens/pay_screen.dart';
import 'package:baitulmaal/view/screens/user/profile_screen.dart';
import 'package:baitulmaal/view/widgets/analytics_container.dart';
import 'package:baitulmaal/view/widgets/payment_list.dart';
import 'package:baitulmaal/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../animations/slide_in_widget.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Consumer<UserProvider>(builder: (ctx, provider, child) {
            return Column(
              children: [
                AnalyticsContainer(
                  percentage: 1 - (provider.analytics.pendingAmount / provider.analytics.totalAmount),
                  topLeftAmount: '₹ ${provider.user.monthlyPayment}',
                  topLeftText: 'Monthly payment',
                  topRightAmount: '₹ ${provider.analytics.yearlyAmount}',
                  topRightText: ' Yearly amount',
                  bottomLeftAmount: '₹ ${provider.analytics.totalAmount}',
                  bottomLeftText: 'Total amount',
                  bottomRightAmount: '₹ ${provider.analytics.pendingAmount}',
                  bottomRightText: 'Pending amount',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: SlideInWidget(
                        delay: 200,
                        child: Text(
                          'Payments',
                          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SlideInWidget(delay: 500, child: ProfileIconButton(user: provider.user)),
                  ],
                ),
                Expanded(
                  child: PaymentList(
                    paymentList: provider.payments,
                    isAdmin: false,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.currency_rupee),
          onPressed: () {
            UserModel user = Provider.of<UserProvider>(context, listen: false).user;

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PayScreen(
                          user: user,
                          isAdmin: false,
                        )));
          }),
    );
  }
}

class ProfileIconButton extends StatelessWidget {
  final UserModel user;

  const ProfileIconButton({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.4),
          blurRadius: 7,
        )
      ]),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          splashColor: Colors.black,
          borderRadius: BorderRadius.circular(30),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.account_circle_outlined,
              size: 30,
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(user: user)));
          },
        ),
      ),
    );
  }
}
