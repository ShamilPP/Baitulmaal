import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meekath/model/success_failure_model.dart';
import 'package:meekath/service/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  Future<bool> login(String username, String password) async {
    SuccessFailModel result =
        await LoginService.loginAccount(username, password);
    successToast(result.message, result.isSucceed);
    if (result.isSucceed) {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('username', result.username!);
    }
    return result.isSucceed;
  }

  Future<bool> createAccount(
    String name,
    String phoneNumber,
    String username,
    String password,
    String confirmPassword,
    String monthlyPayment,
    bool isLogin,
  ) async {
    SuccessFailModel result = await LoginService.createAccount(
      name,
      phoneNumber,
      username,
      password,
      confirmPassword,
      monthlyPayment,
    );
    successToast(result.message, result.isSucceed);
    if (result.isSucceed && isLogin) {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('username', result.username!);
    }
    return result.isSucceed;
  }

  void logout(BuildContext context) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('username');
  }

  void successToast(String text, bool isSuccess) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 16.0,
      textColor: Colors.white,
      webPosition: "center",
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      webBgColor: isSuccess
          ? "linear-gradient(to right, #4CAF50, #4CAF50)"
          : "linear-gradient(to right, #F44336, #F44336)",
    );
  }
}
