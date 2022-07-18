import 'package:baitulmaal/view/widgets/payment_dialog.dart';
import 'package:flutter/material.dart';

import '../../model/payment_model.dart';
import 'my_list_tile.dart';

class PaymentList extends StatelessWidget {
  final List<PaymentModel> paymentList;
  final bool isAdmin;

  const PaymentList({
    Key? key,
    required this.paymentList,
    required this.isAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: paymentList.length,
      itemBuilder: (ctx, index) {
        PaymentModel payment = paymentList[index];

        // Payment status
        String payStatus = '';
        if (payment.verify == 1) {
          payStatus = 'Not verified';
        } else if (payment.verify == 2) {
          payStatus = 'Accepted';
        } else if (payment.verify == 3) {
          payStatus = 'Rejected';
        }

        return MyListTile(
          name: payment.user!.name,
          subText: 'Amount : ${payment.amount}',
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => PaymentDialog(payment: payment, isAdmin: isAdmin),
            );
          },
          suffixText: payStatus,
        );
      },
    );
  }
}
