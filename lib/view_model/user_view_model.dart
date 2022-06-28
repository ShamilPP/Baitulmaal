import 'package:baitulmaal/model/user_model.dart';
import 'package:baitulmaal/model/user_payment.dart';
import 'package:baitulmaal/service/analytics_service.dart';
import 'package:baitulmaal/service/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/enums.dart';

class UserProvider extends ChangeNotifier {
  late String _docId;
  late UserModel _user;
  late List<UserPaymentModel> _userPaymentList;

  String get docId => _docId;

  UserModel get user => _user;

  List<UserPaymentModel> get userPaymentList => _userPaymentList;

  Future initData() async {
    var result = await FirebaseService.getUserWithDocId(docId);
    if (result == null) {
      // Remove DocId from database
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove('user');
    } else {
      _user = result;
    }
    _userPaymentList = AnalyticsService.getUserPaymentList(List.filled(1, _user), PaymentStatus.allPayments);
    notifyListeners();
  }

  void setDocID(String docId) {
    _docId = docId;
  }
}
