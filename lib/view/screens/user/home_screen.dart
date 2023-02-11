import 'package:baitulmaal/model/user_model.dart';
import 'package:baitulmaal/view/screens/pay_screen.dart';
import 'package:baitulmaal/view/widgets/general/analytics_card.dart';
import 'package:baitulmaal/view/widgets/general/payment_list.dart';
import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:baitulmaal/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../animations/slide_animation.dart';
import '../../widgets/screen/user/home/user_popup_menu.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Consumer<UserProvider>(builder: (ctx, provider, child) {
            var analytics = provider.user.analytics!;
            var paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
            return Column(
              children: [
                AnalyticsCard(
                  percentage: 1 - (analytics.pendingAmount / analytics.totalAmount),
                  topLeftAmount: '₹ ${provider.user.monthlyPayment[paymentProvider.meekath]}',
                  topLeftText: 'Monthly payment',
                  topRightAmount: '₹ ${analytics.yearlyAmount}',
                  topRightText: ' Total amount',
                  bottomLeftAmount: '₹ ${analytics.totalAmount}',
                  bottomLeftText: 'Total amount due',
                  bottomRightAmount: '₹ ${analytics.pendingAmount}',
                  bottomRightText: 'Pending amount',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: SlideAnimation(
                        delay: 200,
                        child: Text(
                          'Payments',
                          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // SlideAnimation(delay: 500, child: ProfileIconButton(user: provider.user)),
                    SlideAnimation(delay: 500, child: UserPopupMenu()),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
