import 'package:baitulmaal/model/user_model.dart';
import 'package:baitulmaal/model/user_payment.dart';
import 'package:baitulmaal/service/analytics_service.dart';
import 'package:baitulmaal/service/firebase_service.dart';
import 'package:flutter/material.dart';

import '../service/local_service.dart';
import '../utils/enums.dart';

class UserProvider extends ChangeNotifier {
  late String _docId;
  late UserModel _user;
  late List<UserPaymentModel> _userPaymentList;

  String get docId => _docId;

  UserModel get user => _user;

  List<UserPaymentModel> get userPaymentList => _userPaymentList;

  Future<bool> initData() async {
    var result = await FirebaseService.getUserWithDocId(docId);
    if (result == null) {
      // Remove DocId from database
      LocalService.removeUser();
    } else {
      _user = result;
    }
    _userPaymentList = AnalyticsService.getUserPaymentList(List.filled(1, _user), PaymentStatus.allPayments);
    notifyListeners();
    return true;
  }

  void setDocID(String docId) {
    _docId = docId;
  }
}
