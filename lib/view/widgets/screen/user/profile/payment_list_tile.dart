import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/payment_model.dart';
import '../../../../../model/user_model.dart';
import '../../../../../view_model/admin_view_model.dart';
import '../../../../../view_model/user_view_model.dart';
import '../../../../screens/user/transactions_screen.dart';

class PaymentListTile extends StatelessWidget {
  final UserModel user;
  final bool isAdmin;

  const PaymentListTile({Key? key, required this.user, required this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Payments',
              style: TextStyle(fontSize: 20),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade700),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => UserTransactionScreen(payments: getPayments(context))));
      },
    );
  }

  List<PaymentModel> getPayments(BuildContext context) {
    late List<PaymentModel> payments;
    if (isAdmin) {
      var provider = Provider.of<AdminProvider>(context, listen: false);
      payments = provider.getUserPayments(user);
    } else {
      var provider = Provider.of<UserProvider>(context, listen: false);
      payments = provider.payments;
    }
    return payments;
  }
}
