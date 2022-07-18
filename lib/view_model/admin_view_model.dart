import 'package:baitulmaal/service/analytics_service.dart';
import 'package:baitulmaal/service/firebase_service.dart';
import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/payment_model.dart';
import '../model/total_analytics_model.dart';
import '../model/user_model.dart';
import '../utils/enums.dart';

class AdminProvider extends ChangeNotifier {
  late List<UserModel> _users;
  late List<PaymentModel> _payments;
  late TotalAnalyticsModel _analytics;

  List<UserModel> get users => _users;

  List<PaymentModel> get payments => _payments;

  TotalAnalyticsModel get analytics => _analytics;

  Future<bool> loadDataFromFirebase(BuildContext context) async {
    // fetch meekath
    int meekath = Provider.of<PaymentProvider>(context, listen: false).meekath;

    // Init all data's
    _users = await FirebaseService.getAllUsers();
    _payments = await FirebaseService.getAllPayments(meekath, users);

    updateData();
    return true;
  }

  void updateData() {
    // Get Admin analytics ( ex: total amount,total pending amount, total users, etc..)
    _analytics = AnalyticsService.getAdminOverview(_users, _payments);

    // order with pending amount
    _users.sort((user1, user2) {
      var analytics1 = getUserAnalytics(user1);
      var analytics2 = getUserAnalytics(user2);
      return analytics2.pendingAmount.compareTo(analytics1.pendingAmount);
    });

    notifyListeners();
  }

  // Required for user list ( to check the pending amount )
  TotalAnalyticsModel getUserAnalytics(UserModel user) {
    return AnalyticsService.getUserAnalytics(_payments, user);
  }

  // get user payments from all payments
  List<PaymentModel> getUserPayments(UserModel user) {
    List<PaymentModel> userPayments = [];
    for (var payment in _payments) {
      if (payment.userDocId == user.docId) {
        userPayments.add(payment);
      }
    }
    return userPayments;
  }

  int getTotalAmount(PaymentStatus status) {
    int amount = AnalyticsService.getTotalAmountWithStatus(_payments, status);
    return amount;
  }
}
