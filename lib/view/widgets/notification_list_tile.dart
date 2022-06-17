import 'package:flutter/material.dart';
import 'package:meekath/model/user_payment.dart';
import 'package:meekath/utils/constants.dart';
import 'package:meekath/view_model/payment_view_model.dart';
import 'package:provider/provider.dart';

import '../../../view_model/admin_view_model.dart';
import '../screens/admin/analytics_screen.dart';
import '../screens/user/profile_screen.dart';

class NotificationListTile extends StatelessWidget {
  final UserPaymentModel userPayment;

  const NotificationListTile({
    Key? key,
    required this.userPayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userPayment.user.name,
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  'Amount : ${userPayment.payment.amount}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ActionButton(
                      text: 'Accept',
                      color: Colors.green,
                      icon: Icons.done,
                      status: paymentAccepted,
                      userPayment: userPayment,
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
                    ActionButton(
                      text: 'Reject',
                      color: Colors.red,
                      icon: Icons.close,
                      status: paymentRejected,
                      userPayment: userPayment,
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () => showDialog(
              context: context,
              builder: (ctx) => PaymentDialog(userPayment: userPayment)),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  final int status;
  final UserPaymentModel userPayment;

  const ActionButton({
    Key? key,
    required this.text,
    required this.color,
    required this.icon,
    required this.status,
    required this.userPayment,
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
              AdminProvider adminProvider =
                  Provider.of<AdminProvider>(context, listen: false);
              PaymentProvider paymentProvider =
                  Provider.of<PaymentProvider>(context, listen: false);
              // Accept + ing.. = Accepting..
              adminProvider.showMyDialog(context, text + 'ing..');
              await paymentProvider.updatePayment(
                  userPayment.payment.docId!, status);
              await adminProvider.initData();
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}

class PaymentDialog extends StatelessWidget {
  final UserPaymentModel userPayment;
  final bool ifAdmin;

  const PaymentDialog(
      {Key? key, required this.userPayment, this.ifAdmin = true})
      : super(key: key);

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
                  text:
                      'Date : ${userPayment.payment.dateTime.day}/${userPayment.payment.dateTime.month}/${userPayment.payment.dateTime.year}',
                ),
                DetailsText(
                  text:
                      'User status : ${userPayment.user.analytics!.isPending ? 'PENDING' : 'COMPLETED'}',
                ),
                DetailsText(
                  text: 'Monthly amount : ₹ ${userPayment.user.monthlyPayment}',
                ),
                DetailsText(
                  text:
                      'Months : ${userPayment.payment.amount ~/ userPayment.user.monthlyPayment} Months',
                ),
                ifAdmin
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ProfileScreen(
                                              user: userPayment.user)));
                                },
                                child: const Text('View profile'))),
                      )
                    : const SizedBox()
              ],
            ),
          )),
        ),
      ],
    );
  }
}
