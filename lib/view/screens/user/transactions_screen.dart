import 'package:baitulmaal/model/payment_model.dart';
import 'package:flutter/material.dart';

import '../transactions_screen.dart';

class UserTransactionScreen extends StatelessWidget {
  final List<PaymentModel> payments;

  const UserTransactionScreen({Key? key, required this.payments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TransactionScreen(
          payments: payments,
          isAdmin: false,
        ),
      ),
    );
  }
}
