import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meekath/model/payment_model.dart';
import 'package:meekath/model/user_model.dart';
import 'package:meekath/utils/constants.dart';
import 'package:meekath/view_model/admin_view_model.dart';
import 'package:meekath/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

import '../model/user_payment.dart';
import '../service/analytics_service.dart';
import '../service/firebase_service.dart';

class PaymentProvider extends ChangeNotifier {
  bool? _isLoading;

  bool? get isLoading => _isLoading;

  void setLoading(bool? loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void uploadPayment(
      BuildContext context, String money, UserModel user, bool isAdmin) async {
    // start loading
    setLoading(true);
    // Check entered amount is null
    int? amount = int.tryParse(money);
    if (amount == null || amount == 0) {
      await Future.delayed(const Duration(seconds: 2));
      setLoading(null);
    } else {
      // When the admin pay the user, automatically verified
      int verify = paymentNotVerified;
      if (isAdmin) {
        verify = paymentAccepted;
      }
      // upload payment to firebase
      PaymentModel payment = PaymentModel(
          userDocId: user.docId,
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
      setLoading(false);
      //after few seconds show payment screen
      await Future.delayed(const Duration(seconds: 3));
      setLoading(null);
      Navigator.pop(context);
      notifyListeners();
    }
  }

  Future updatePayment(String docId, int status) async {
    await FirebaseService.updatePayment(docId, status);
  }

  List<UserPaymentModel> getUserPaymentList(List<UserModel> users, int status) {
    List<UserPaymentModel> list = AnalyticsService.getUserPaymentList(
      users,
      status,
    );
    return list;
  }
}
