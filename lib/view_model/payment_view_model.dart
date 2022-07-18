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

  PayUploadStatus _uploadStatus = PayUploadStatus.none;

  int get meekath => _meekath;

  PayUploadStatus get uploadStatus => _uploadStatus;

  void setUploadStatus(PayUploadStatus status) {
    _uploadStatus = status;
    notifyListeners();
  }

  void uploadPayment(BuildContext context, String money, UserModel user, bool isAdmin) async {
    // start loading
    setUploadStatus(PayUploadStatus.loading);
    // Check entered amount is null
    int? amount = int.tryParse(money);
    if (amount == null || amount == 0) {
      // amount == null return failed checkmark after 2 second
      await Future.delayed(const Duration(seconds: 2));
      setUploadStatus(PayUploadStatus.failed);
      // remove failed checkmark after 3 second
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
          userDocId: user.docId!, amount: amount, verify: verify, meekath: meekath, dateTime: DateTime.now());

      await FirebaseService.uploadPayment(payment);

      // Refresh all data
      if (isAdmin) {
        await Provider.of<AdminProvider>(context, listen: false).initData(context);
      } else {
        await Provider.of<UserProvider>(context, listen: false).initData();
      }
      // payment finished show checkmark
      setUploadStatus(PayUploadStatus.success);
      //after few seconds show payment screen
      await Future.delayed(const Duration(seconds: 3));
      setUploadStatus(PayUploadStatus.none);
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
