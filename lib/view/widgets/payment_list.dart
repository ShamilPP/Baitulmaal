import 'package:flutter/material.dart';

import '../../model/user_payment.dart';
import 'my_list_tile.dart';
import 'notification_list_tile.dart';

class PaymentList extends StatelessWidget {
  final List<UserPaymentModel> paymentList;
  final bool ifAdmin;

  const PaymentList({Key? key, required this.paymentList, this.ifAdmin = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: paymentList.length,
      itemBuilder: (ctx, index) {
        UserPaymentModel pay = paymentList[index];
        String _status = '';
        if (pay.payment.verify == 1) {
          _status = 'Not verified';
        } else if (pay.payment.verify == 2) {
          _status = 'Accepted';
        } else if (pay.payment.verify == 3) {
          _status = 'Rejected';
        }
        return MyListTile(
          name: pay.user.name,
          subText: 'Amount : ${pay.payment.amount}',
          onTap: () {
            showDialog(context: context, builder: (ctx) => PaymentDialog(userPayment: pay, ifAdmin: ifAdmin));
          },
          suffixText: _status,
        );
      },
    );
  }
}
