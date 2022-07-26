import 'package:baitulmaal/model/payment_model.dart';
import 'package:baitulmaal/model/user_model.dart';
import 'package:baitulmaal/view_model/admin_view_model.dart';
import 'package:baitulmaal/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/analytics_service.dart';
import '../service/firebase_service.dart';
import '../utils/enums.dart';

class PaymentProvider extends ChangeNotifier {
  int _meekath = DateTime.now().year;

  Status _uploadStatus = Status.none;

  int get meekath => _meekath;

  Status get uploadStatus => _uploadStatus;

  void setUploadStatus(Status status) {
    _uploadStatus = status;
    notifyListeners();
  }

  void uploadPayment(BuildContext context, String money, UserModel user, bool isAdmin) async {
    // start loading
    setUploadStatus(Status.loading);
    // Check entered amount is null
    int? amount = int.tryParse(money);
    if (amount == null || amount == 0) {
      // amount == null return failed checkmark after 2 second
      await Future.delayed(const Duration(seconds: 2));
      setUploadStatus(Status.failed);
      // remove failed checkmark after 3 second
      await Future.delayed(const Duration(seconds: 3));
      setUploadStatus(Status.none);
    } else {
      // When the admin pay the user, automatically verified
      int verify = PaymentStatus.notVerified.index;
      if (isAdmin) {
        verify = PaymentStatus.accepted.index;
      }
      // upload payment to firebase
      PaymentModel payment = PaymentModel(
          userDocId: user.docId!, amount: amount, verify: verify, meekath: meekath, dateTime: DateTime.now());

      await FirebaseService.uploadPayment(payment);

      // Refresh all data
      if (isAdmin) {
        await Provider.of<AdminProvider>(context, listen: false).loadDataFromFirebase(context);
      } else {
        await Provider.of<UserProvider>(context, listen: false).initData();
      }
      // payment finished show checkmark
      setUploadStatus(Status.completed);
      //after few seconds show payment screen
      await Future.delayed(const Duration(seconds: 3));
      setUploadStatus(Status.none);
      Navigator.pop(context);
    }
  }

  Future<bool> updatePayment(String docId, PaymentStatus status) async {
    var result = await FirebaseService.updatePayment(docId, status.index);
    return result;
  }

  List<PaymentModel> getPaymentListWithStatus(List<PaymentModel> payments, PaymentStatus status) {
    List<PaymentModel> list = AnalyticsService.getPaymentListWithStatus(payments, status);
    return list;
  }

  void setMeekath(int meekath) {
    _meekath = meekath;
    notifyListeners();
  }

  List<int> getMeekathList() {
    List<int> allMeekath = [];
    for (int i = 2021; i <= DateTime.now().year; i++) {
      allMeekath.add(i);
    }
    return allMeekath;
  }
}
