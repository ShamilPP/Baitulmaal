import 'package:flutter/material.dart';
import 'package:meekath/model/user_model.dart';
import 'package:meekath/utils/colors.dart';

import '../../repo/analytics_service.dart';
import '../../utils/constants.dart';
import 'payment_list.dart';

class TransactionScreen extends StatelessWidget {
  final List<UserModel> users;

  const TransactionScreen({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 100,
            child: AppBar(
              backgroundColor: primaryColor,
              title: const Text(
                "Transactions",
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              bottom: const TabBar(
                tabs: [
                  Tab(text: "All"),
                  Tab(text: "Accepted"),
                  Tab(text: "Rejected"),
                  Tab(text: "Not verified"),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                PaymentList(
                  paymentList: AnalyticsService.getUserPaymentList(
                    users,
                    allPayments,
                  ),
                ),
                PaymentList(
                  paymentList: AnalyticsService.getUserPaymentList(
                    users,
                    paymentAccepted,
                  ),
                ),
                PaymentList(
                  paymentList: AnalyticsService.getUserPaymentList(
                    users,
                    paymentRejected,
                  ),
                ),
                PaymentList(
                  paymentList: AnalyticsService.getUserPaymentList(
                    users,
                    paymentNotVerified,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
