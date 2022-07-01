import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/user_payment.dart';
import '../screens/admin/analytics_screen.dart';
import '../screens/user/profile_screen.dart';

class PaymentDialog extends StatelessWidget {
  final UserPaymentModel userPayment;
  final bool isAdmin;

  const PaymentDialog({Key? key, required this.userPayment, required this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailsText(
                    text: 'Name : ${userPayment.user.name}',
                  ),
                  DetailsText(
                    text: 'Amount : ₹ ${userPayment.payment.amount}',
                  ),
                  DetailsText(
                    text: 'Date : ${DateFormat('EEE, MMM d').format(userPayment.payment.dateTime)}',
                  ),
                  DetailsText(
                    text: 'Time : ${DateFormat('h : m a').format(userPayment.payment.dateTime)}',
                  ),
                  DetailsText(
                    text: 'Meekath : ${userPayment.payment.meekath}',
                  ),
                  isAdmin
                      ? DetailsText(
                          text: 'User status : ${userPayment.user.analytics!.isPending ? 'PENDING' : 'COMPLETED'}',
                        )
                      : const SizedBox(),
                  isAdmin
                      ? DetailsText(
                          text: 'Monthly amount : ₹ ${userPayment.user.monthlyPayment}',
                        )
                      : const SizedBox(),
                  DetailsText(
                    text: 'Months : ${userPayment.payment.amount ~/ userPayment.user.monthlyPayment} Months',
                  ),
                  isAdmin
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Center(
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) => ProfileScreen(user: userPayment.user)));
                                  },
                                  child: const Text('View profile'))),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
