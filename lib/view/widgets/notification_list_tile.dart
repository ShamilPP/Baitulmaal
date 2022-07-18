import 'package:baitulmaal/view/widgets/payment_dialog.dart';
import 'package:baitulmaal/view_model/admin_view_model.dart';
import 'package:baitulmaal/view_model/notification_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/payment_model.dart';
import '../../utils/enums.dart';
import '../../view_model/payment_view_model.dart';

class NotificationListTile extends StatelessWidget {
  final int index;
  final PaymentModel payment;

  const NotificationListTile({
    Key? key,
    required this.index,
    required this.payment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Card(
        elevation: 7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.user!.name,
                  style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  'Amount : ${payment.amount}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Accept Button
                    ActionButton(
                      index: index,
                      text: 'Accept',
                      color: Colors.green,
                      icon: Icons.done,
                      status: PaymentStatus.accepted,
                      payment: payment,
                    ),

                    const Expanded(flex: 1, child: SizedBox()),

                    // Reject Button
                    ActionButton(
                      index: index,
                      text: 'Reject',
                      color: Colors.red,
                      icon: Icons.close,
                      status: PaymentStatus.rejected,
                      payment: payment,
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () => showDialog(context: context, builder: (ctx) => PaymentDialog(payment: payment, isAdmin: true)),
        ),
      ),
    );
  }
}

// Use for Accept button or Reject button
class ActionButton extends StatelessWidget {
  final int index;
  final String text;
  final Color color;
  final IconData icon;
  final PaymentStatus status;
  final PaymentModel payment;

  const ActionButton({
    Key? key,
    required this.index,
    required this.text,
    required this.color,
    required this.icon,
    required this.status,
    required this.payment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 8,
      child: SizedBox(
        height: 50,
        child: Material(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: const TextStyle(fontSize: 22, color: Colors.white),
                )
              ],
            ),
            onTap: () async {
              PaymentProvider paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
              AdminProvider adminProvider = Provider.of<AdminProvider>(context, listen: false);
              NotificationProvider notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
              if (notificationProvider.paymentNotVerifiedList.contains(payment)) {
                // Update payment in firebase
                paymentProvider.updatePayment(payment.docId!, status);
                // Update all data's
                adminProvider.initData(notificationProvider.listKey.currentContext!);
                // animation
                notificationProvider.paymentNotVerifiedList.remove(payment);
                notificationProvider.listKey.currentState!.removeItem(
                  index,
                  (context, animation) {
                    return SizeTransition(
                      sizeFactor: animation,
                      child: NotificationListTile(
                        index: index,
                        payment: payment,
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
