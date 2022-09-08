import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/payment_model.dart';
import '../animations/slide_animation.dart';
import '../screens/user/profile_screen.dart';
import 'details_text.dart';

class PaymentDialog extends StatelessWidget {
  final PaymentModel payment;
  final bool isAdmin;

  const PaymentDialog({
    Key? key,
    required this.payment,
    required this.isAdmin,
  }) : super(key: key);

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
                  SlideAnimation(
                    delay: 100,
                    child: DetailsText(
                      text: 'Name : ${payment.user!.name}',
                    ),
                  ),
                  SlideAnimation(
                    delay: 200,
                    child: DetailsText(
                      text: 'Amount : ₹ ${payment.amount} (${payment.amount ~/ payment.user!.monthlyPayment[payment.meekath]!})',
                    ),
                  ),
                  SlideAnimation(
                    delay: 300,
                    child: DetailsText(
                      text: 'Date : ${DateFormat('EEE, MMM d').format(payment.dateTime)}',
                    ),
                  ),
                  SlideAnimation(
                    delay: 400,
                    child: DetailsText(
                      text: 'Time : ${DateFormat('h : m a').format(payment.dateTime)}',
                    ),
                  ),
                  SlideAnimation(
                    delay: 500,
                    child: DetailsText(
                      text: 'Meekath : ${payment.meekath}',
                    ),
                  ),
                  isAdmin
                      ? SlideAnimation(
                          delay: 700,
                          child: DetailsText(
                            text: 'Monthly amount : ₹ ${payment.user!.monthlyPayment[payment.meekath]}',
                          ),
                        )
                      : const SizedBox(),
                  isAdmin
                      ? SlideAnimation(
                          delay: 800,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) => ProfileScreen(user: payment.user!)));
                                    },
                                    child: const Text('View profile'))),
                          ),
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
