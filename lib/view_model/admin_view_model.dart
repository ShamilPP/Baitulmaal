import 'package:flutter/material.dart';
import 'package:meekath/model/admin_overview_model.dart';
import 'package:meekath/model/user_payment.dart';
import 'package:meekath/repo/analytics_service.dart';
import 'package:meekath/repo/firebase_service.dart';
import 'package:meekath/utils/constants.dart';

import '../model/user_model.dart';

class AdminProvider extends ChangeNotifier {
  int _currentBottomNavigator = 2;
  late AdminOverviewModel _adminOverview;
  late List<UserModel> _users;
  late int _initialLength;
  late List<UserPaymentModel> _paymentNotVerifiedList;

  int get currentBottomNavigator => _currentBottomNavigator;

  AdminOverviewModel get adminOverview => _adminOverview;

  List<UserModel> get users => _users;

  List<UserPaymentModel> get paymentNotVerifiedList => _paymentNotVerifiedList;

  int get initialLength => _initialLength;

  Future initData() async {
    // Init all data's
    _users = await FirebaseService.getAllUsers();

    // Init payment not verified list
    _paymentNotVerifiedList =
        AnalyticsService.getUserPaymentList(users, paymentNotVerified);
    _initialLength = paymentNotVerifiedList.length;

    // Init admin overview
    _adminOverview = await AnalyticsService.getAdminOverview(_users);

    _users.sort((a, b) {
      if (a.analytics!.isPending) {
        return -1;
      }
      return 1;
    });
    notifyListeners();
  }

  setCurrentBottomNavigator(int value) {
    _currentBottomNavigator = value;
    notifyListeners();
  }

  removePaymentNotVerifiedItem(UserPaymentModel userPayment) {
    _paymentNotVerifiedList.remove(userPayment);
    notifyListeners();
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
