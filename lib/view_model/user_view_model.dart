import 'package:flutter/cupertino.dart';
import 'package:meekath/model/user_model.dart';
import 'package:meekath/model/user_payment.dart';
import 'package:meekath/repo/analytics_service.dart';
import 'package:meekath/repo/firebase_service.dart';
import 'package:meekath/utils/constants.dart';

class UserProvider extends ChangeNotifier {
  late UserModel _user;
  late List<UserPaymentModel> _userPaymentList;
  bool? _isLoading;

  UserModel get user => _user;

  List<UserPaymentModel> get userPaymentList => _userPaymentList;

  bool? get isLoading => _isLoading;

  initData(String username) async {
    _user = (await FirebaseService.getUser(username, true))!;
    _userPaymentList =
        AnalyticsService.getUserPaymentList(List.filled(1, _user), allPayments);
  }

  void setLoading(bool? loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void startPayment(String text) async {
    // start loading
    setLoading(true);
    // upload payment to firebase
    if (text != "") {
      int amount = int.parse(text);
      await FirebaseService.uploadPayment(amount, user.docId);
      await initData(user.username);
      // payment finished show checkmark
      setLoading(false);
      //after few seconds show payment screen
      await Future.delayed(const Duration(seconds: 3));
      setLoading(null);
      notifyListeners();
    }
  }
}
