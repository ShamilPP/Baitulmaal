import 'package:baitulmaal/model/response.dart';
import 'package:baitulmaal/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  Future<bool> login(String username, String password) async {
    Response result = await LoginService.loginAccount(username, password);
    successToast(result.message, result.isSuccessful);
    if (result.isSuccessful) {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('user', result.value!);
    }
    return result.isSuccessful;
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
    Response result = await LoginService.createAccount(
      name,
      phoneNumber,
      username,
      password,
      confirmPassword,
      monthlyPayment,
    );
    successToast(result.message, result.isSuccessful);
    if (result.isSuccessful && isLogin) {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('user', result.value!);
    }
    return result.isSuccessful;
  }

  void logout(BuildContext context) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('user');
  }

  void successToast(String text, bool isSuccess) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 16.0,
      textColor: Colors.white,
      webPosition: "center",
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      webBgColor:
          isSuccess ? "linear-gradient(to right, #4CAF50, #4CAF50)" : "linear-gradient(to right, #F44336, #F44336)",
    );
  }
}
