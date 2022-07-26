import 'package:baitulmaal/service/analytics_service.dart';
import 'package:baitulmaal/service/firebase_service.dart';
import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/analytics_model.dart';
import '../model/payment_model.dart';
import '../model/user_model.dart';
import '../utils/enums.dart';

class AdminProvider extends ChangeNotifier {
  late List<UserModel> _users;
  List<PaymentModel> _payments = [];
  AnalyticsModel? _analytics;

  // For firebase payment fetching
  late Status _paymentStatus;

  List<UserModel> get users => _users;

  List<PaymentModel> get payments => _payments;

  AnalyticsModel? get analytics => _analytics;

  Status get paymentStatus => _paymentStatus;

  Future<bool> loadDataFromFirebase(BuildContext context) async {
    // fetch meekath
    int meekath = Provider.of<PaymentProvider>(context, listen: false).meekath;

    // Get users from firebase
    _users = await FirebaseService.getAllUsers();

    // Get Payments from firebase (not waiting)
    _paymentStatus = Status.loading;
    FirebaseService.getAllPayments(meekath, users).then((result) async {
      _paymentStatus = Status.completed;
      _payments = result;
      updateData();
    });

    updateData();
    return true;
  }

  void updateData() {
    // Get Admin analytics ( ex: total amount,total pending amount, total users, etc..)
    if (paymentStatus == Status.completed) _analytics = AnalyticsService.getAdminOverview(_users, _payments);

    // order with pending amount
    _users.sort((user1, user2) {
      if (paymentStatus == Status.completed) {
        var analytics1 = getUserAnalytics(user1);
        var analytics2 = getUserAnalytics(user2);
        return analytics2.pendingAmount.compareTo(analytics1.pendingAmount);
      } else {
        return user1.name.compareTo(user2.name);
      }
    });

    notifyListeners();
  }

  // Required for user list ( to check the pending amount )
  AnalyticsModel getUserAnalytics(UserModel user) {
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

  showLoadingDialog(BuildContext context, String message) {
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
