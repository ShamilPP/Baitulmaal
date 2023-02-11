import 'package:baitulmaal/service/analytics_service.dart';
import 'package:baitulmaal/service/firebase_service.dart';
import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/analytics.dart';
import '../model/payment.dart';
import '../model/user.dart';
import '../utils/enums.dart';

class AdminProvider extends ChangeNotifier {
  late List<User> _users;
  List<Payment> _payments = [];
  Analytics? _analytics;

  // For firebase payment fetching
  late Status _paymentStatus;

  List<User> get users => _users;

  List<Payment> get payments => _payments;

  Analytics? get analytics => _analytics;

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
      updateData(meekath);
    });

    updateData(meekath);
    return true;
  }

  void updateData(int meekath) {
    // Set all user analytics
    if (paymentStatus == Status.completed) {
      for (var user in _users) {
        user.analytics = AnalyticsService.getUserAnalytics(getUserPayments(user), user, meekath);
      }
    }

    // Get Admin analytics ( ex: total amount,total pending amount, total users, etc..)
    if (paymentStatus == Status.completed) _analytics = AnalyticsService.getAdminOverview(_users, _payments);

    // order with pending amount
    _users.sort((user1, user2) {
      if (paymentStatus == Status.completed) {
        return user2.analytics!.pendingAmount.compareTo(user1.analytics!.pendingAmount);
      } else {
        return user1.name.compareTo(user2.name);
      }
    });

    notifyListeners();
  }

  // get user payments from all payments
  List<Payment> getUserPayments(User user) {
    List<Payment> userPayments = [];
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
