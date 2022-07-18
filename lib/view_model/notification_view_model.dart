import 'package:baitulmaal/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/payment_model.dart';
import 'admin_view_model.dart';

class NotificationProvider extends ChangeNotifier {
  final listKey = GlobalKey<AnimatedListState>();
  late List<PaymentModel> _paymentNotVerifiedList;

  List<PaymentModel> get paymentNotVerifiedList => _paymentNotVerifiedList;

  void setNotVerifiedList(List<PaymentModel> notVerifiedList) {
    _paymentNotVerifiedList = notVerifiedList;
  }

  void updatePayment(BuildContext context, PaymentModel payment, PaymentStatus status) {
    AdminProvider adminProvider = Provider.of<AdminProvider>(context, listen: false);
    int paymentIndex = adminProvider.payments.indexWhere((_payment) {
      if (payment.docId == _payment.docId) {
        return true;
      } else {
        return false;
      }
    });
    adminProvider.payments[paymentIndex] = PaymentModel(
      verify: status.index,
      docId: adminProvider.payments[paymentIndex].docId,
      userDocId: adminProvider.payments[paymentIndex].userDocId,
      user: adminProvider.payments[paymentIndex].user,
      amount: adminProvider.payments[paymentIndex].amount,
      meekath: adminProvider.payments[paymentIndex].meekath,
      dateTime: adminProvider.payments[paymentIndex].dateTime,
    );
    _paymentNotVerifiedList.remove(payment);
    adminProvider.updateData();
  }
}
