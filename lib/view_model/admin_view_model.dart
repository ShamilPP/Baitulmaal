import 'package:flutter/material.dart';
import 'package:meekath/model/admin_overview_model.dart';
import 'package:meekath/model/user_payment.dart';
import 'package:meekath/service/analytics_service.dart';
import 'package:meekath/service/firebase_service.dart';
import 'package:meekath/utils/constants.dart';

import '../model/user_model.dart';

class AdminProvider extends ChangeNotifier {
  late AdminOverviewModel _adminOverview;
  late List<UserModel> _users;
  late List<UserPaymentModel> _paymentNotVerifiedList;

  AdminOverviewModel get adminOverview => _adminOverview;

  List<UserModel> get users => _users;

  List<UserPaymentModel> get paymentNotVerifiedList => _paymentNotVerifiedList;

  Future initData() async {
    // Init all data's
    _users = await FirebaseService.getAllUsers();

    // Init payment not verified list
    _paymentNotVerifiedList =
        AnalyticsService.getUserPaymentList(users, paymentNotVerified);

    // Init admin overview
    _adminOverview = await AnalyticsService.getAdminOverview(_users);

    // order with pending amount
    _users.sort((a, b) =>
        b.analytics!.pendingAmount.compareTo(a.analytics!.pendingAmount));

    notifyListeners();
  }

  int getTotalAmount(int status) {
    // fetching all payment list
    List<UserPaymentModel> list =
        AnalyticsService.getUserPaymentList(users, status);
    // adding all amount
    int amount = 0;
    for (var pay in list) {
      amount = amount + pay.payment.amount;
    }
    // returning total amount
    return amount;
  }

  showMyDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 30),
              Text(
                message,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        );
      },
    );
  }
}
