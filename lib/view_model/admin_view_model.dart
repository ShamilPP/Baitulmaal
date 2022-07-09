import 'package:baitulmaal/model/admin_overview_model.dart';
import 'package:baitulmaal/model/user_payment.dart';
import 'package:baitulmaal/service/analytics_service.dart';
import 'package:baitulmaal/service/firebase_service.dart';
import 'package:baitulmaal/view_model/notification_view_model.dart';
import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../utils/enums.dart';

class AdminProvider extends ChangeNotifier {
  late List<UserModel> _users;

  List<UserModel> get users => _users;

  Future<bool> initData(BuildContext context) async {
    // fetch meekath
    int meekath = Provider.of<PaymentProvider>(context, listen: false).meekath;
    // Init all data's
    _users = await FirebaseService.getAllUsers(meekath);
    // order with pending amount
    _users.sort((a, b) => b.analytics!.pendingAmount.compareTo(a.analytics!.pendingAmount));
    //init payment not verified list
    List<UserPaymentModel> notVerifiedList = AnalyticsService.getUserPaymentList(users, PaymentStatus.notVerified);
    // init not verified list
    Provider.of<NotificationProvider>(context, listen: false).setNotVerifiedList(notVerifiedList);

    notifyListeners();
    return true;
  }

  AdminOverviewModel getAdminOverview() {
    AdminOverviewModel adminOverview = AnalyticsService.getAdminOverview(_users);
    return adminOverview;
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
