import 'package:flutter/cupertino.dart';
import 'package:meekath/model/user_model.dart';
import 'package:meekath/model/user_payment.dart';
import 'package:meekath/service/analytics_service.dart';
import 'package:meekath/service/firebase_service.dart';
import 'package:meekath/utils/constants.dart';

class UserProvider extends ChangeNotifier {
  late UserModel _user;
  late List<UserPaymentModel> _userPaymentList;

  UserModel get user => _user;

  List<UserPaymentModel> get userPaymentList => _userPaymentList;

  Future initData(String username) async {
    _user = (await FirebaseService.getUser(username, true))!;
    _userPaymentList =
        AnalyticsService.getUserPaymentList(List.filled(1, _user), allPayments);
    notifyListeners();
  }
}
