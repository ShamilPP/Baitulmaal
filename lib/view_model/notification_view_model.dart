import 'package:baitulmaal/model/user_payment.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  final listKey = GlobalKey<AnimatedListState>();
  late List<UserPaymentModel> _paymentNotVerifiedList;
  List<UserPaymentModel> get paymentNotVerifiedList => _paymentNotVerifiedList;

  void setNotVerifiedList(List<UserPaymentModel> notVerifiedList) {
    _paymentNotVerifiedList = notVerifiedList;
  }
}
