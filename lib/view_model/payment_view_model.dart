import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:baitulmaal/model/payment_model.dart';
import 'package:baitulmaal/model/user_model.dart';
import 'package:baitulmaal/view_model/admin_view_model.dart';
import 'package:baitulmaal/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

import '../model/user_payment.dart';
import '../service/analytics_service.dart';
import '../service/firebase_service.dart';
import '../utils/enums.dart';

class PaymentProvider extends ChangeNotifier {
  PayUploadStatus _uploadStatus = PayUploadStatus.none;

  PayUploadStatus get uploadStatus => _uploadStatus;

  void setUploadStatus(PayUploadStatus status) {
    _uploadStatus = status;
    notifyListeners();
  }

  void uploadPayment(
      BuildContext context, String money, UserModel user, bool isAdmin) async {
    // start loading
    setUploadStatus(PayUploadStatus.loading);
    // Check entered amount is null
    int? amount = int.tryParse(money);
    if (amount == null || amount == 0) {
      // amount == null return failed checkmark after 2 second
      await Future.delayed(const Duration(seconds: 2));
      setUploadStatus(PayUploadStatus.failed);
      // remove failed checkmark after 2 second
      await Future.delayed(const Duration(seconds: 3));
      setUploadStatus(PayUploadStatus.none);
    } else {
      // When the admin pay the user, automatically verified
      int verify = PaymentStatus.notVerified.index;
      if (isAdmin) {
        verify = PaymentStatus.accepted.index;
      }
      // upload payment to firebase
      PaymentModel payment = PaymentModel(
          userDocId: user.docId!,
          amount: amount,
          verify: verify,
          dateTime: DateTime.now());

      await FirebaseService.uploadPayment(payment);

      // Refresh all data
      if (isAdmin) {
        await Provider.of<AdminProvider>(context, listen: false).initData();
      } else {
        UserProvider provider =
            Provider.of<UserProvider>(context, listen: false);

        await provider.initData(provider.user.username);
      }
      // payment finished show checkmark
      setUploadStatus(PayUploadStatus.success);
      //after few seconds show payment screen
      await Future.delayed(const Duration(seconds: 3));
      setUploadStatus(PayUploadStatus.none);
      Navigator.pop(context);
      notifyListeners();
    }
  }

  Future updatePayment(String docId, PaymentStatus status) async {
    await FirebaseService.updatePayment(docId, status.index);
  }

  List<UserPaymentModel> getUserPaymentList(
      List<UserModel> users, PaymentStatus status) {
    List<UserPaymentModel> list = AnalyticsService.getUserPaymentList(
      users,
      status,
    );
    return list;
  }
}
