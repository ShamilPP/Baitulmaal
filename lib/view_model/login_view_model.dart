import 'package:baitulmaal/model/response.dart';
import 'package:baitulmaal/service/local_service.dart';
import 'package:baitulmaal/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginProvider extends ChangeNotifier {
  Future<bool> login(String username, String password) async {
    Response result = await LoginService.loginAccount(username, password);
    showToast(result.value, result.isSuccess);
    if (result.isSuccess) {
      LocalService.saveUser(result.value!);
    }
    return result.isSuccess;
  }

  Future<bool> createAccount(
    String name,
    String phoneNumber,
    String username,
    String password,
    String confirmPassword,
    String monthlyPayment,
  ) async {
    Response result = await LoginService.createAccount(
      name,
      phoneNumber,
      username.toLowerCase(),
      password,
      confirmPassword,
      monthlyPayment,
    );
    showToast(result.value, result.isSuccess);
    return result.isSuccess;
  }

  void logout() async {
    LocalService.removeUser();
  }

  void showToast(String text, bool isSuccess) {
    Fluttertoast.showToast(
      msg: isSuccess ? 'Logged in' : text,
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
