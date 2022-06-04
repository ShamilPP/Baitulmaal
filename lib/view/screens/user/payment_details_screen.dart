import 'package:flutter/material.dart';
import 'package:meekath/model/user_payment.dart';
import 'package:meekath/view/screens/user/transaction_screen.dart';

import '../../../model/user_model.dart';
import '../../../repo/analytics_service.dart';
import '../../../utils/constants.dart';

class PaymentDetailsScreen extends StatelessWidget {
  final UserModel user;

  const PaymentDetailsScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Payments"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              ProfileDetailsText(
                  text: "Total amount : ₹ ${user.analytics!.totalAmount}"),
              ProfileDetailsText(
                text:
                    "Total received amount : ₹ ${user.analytics!.totalReceivedAmount}",
              ),
              ProfileDetailsText(
                text:
                    "Total pending amount : ₹ ${user.analytics!.pendingAmount}",
              ),
              ProfileDetailsText(
                text:
                    "Extra amount : ₹ ${(user.analytics!.totalAmount - user.analytics!.totalReceivedAmount - user.analytics!.pendingAmount).abs()}",
              ),
              const SizedBox(height: 10),
              ProfileDetailsText(
                text:
                    "Total not verified amount : ₹ ${getUserTotalPayment(paymentNotVerified)}",
              ),
              ProfileDetailsText(
                text:
                    "Total accepted amount : ₹ ${getUserTotalPayment(paymentAccepted)}",
              ),
              ProfileDetailsText(
                text:
                    "Total rejected amount : ₹ ${getUserTotalPayment(paymentRejected)}",
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => UserTransactionScreen(user: user)));
                  },
                  child: const Text(
                    'View all payments',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  int getUserTotalPayment(int status) {
    List<UserModel> users = [user];
    List<UserPaymentModel> analytics =
        AnalyticsService.getUserPaymentList(users, status);
    int totalAmount = AnalyticsService.getTotalAmount(analytics);
    return totalAmount;
  }
}

class ProfileDetailsText extends StatelessWidget {
  final String text;

  const ProfileDetailsText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
