import 'package:baitulmaal/model/admin_overview_model.dart';
import 'package:baitulmaal/model/user_payment.dart';
import 'package:baitulmaal/service/analytics_service.dart';
import 'package:baitulmaal/service/firebase_service.dart';
import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../utils/enums.dart';

class AdminProvider extends ChangeNotifier {
  late AdminOverviewModel _adminOverview;
  late List<UserModel> _users;
  late List<UserPaymentModel> _paymentNotVerifiedList;

  AdminOverviewModel get adminOverview => _adminOverview;

  List<UserModel> get users => _users;

  List<UserPaymentModel> get paymentNotVerifiedList => _paymentNotVerifiedList;

  Future initData(BuildContext context) async {
    //fetch meekath
    int meekath = Provider.of<PaymentProvider>(context, listen: false).meekath;
    // Init all data's
    _users = await FirebaseService.getAllUsers(meekath);

    // Init payment not verified list
    _paymentNotVerifiedList = AnalyticsService.getUserPaymentList(users, PaymentStatus.notVerified);

    // Init admin overview
    _adminOverview = await AnalyticsService.getAdminOverview(_users);

    // order with pending amount
    _users.sort((a, b) => b.analytics!.pendingAmount.compareTo(a.analytics!.pendingAmount));

    notifyListeners();
  }

  int getTotalAmount(PaymentStatus status) {
    // fetching all payment list
    List<UserPaymentModel> list = AnalyticsService.getUserPaymentList(users, status);
    // adding all amount
    int amount = 0;
    for (var pay in list) {
      amount = amount + pay.payment.amount;
    }
    // returning total amount
    return amount;
  }
}
