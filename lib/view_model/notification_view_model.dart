import 'package:flutter/material.dart';

import '../model/payment_model.dart';

class NotificationProvider extends ChangeNotifier {
  final listKey = GlobalKey<AnimatedListState>();
  late List<PaymentModel> _paymentNotVerifiedList;

  List<PaymentModel> get paymentNotVerifiedList => _paymentNotVerifiedList;

  void setNotVerifiedList(List<PaymentModel> notVerifiedList) {
    _paymentNotVerifiedList = notVerifiedList;
  }
}
