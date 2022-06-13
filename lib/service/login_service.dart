import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meekath/model/user_model.dart';
import 'package:meekath/service/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static Future<bool> loginAccount(String username, String password) async {
    UserModel? user = await FirebaseService.getUser(username, false);
    final prefs = await SharedPreferences.getInstance();
    if (username == 'admin' &&
        password == await FirebaseService.getAdminPassword()) {
      await prefs.setString('username', 'admin');
      return true;
    } else if (!checkInvalid(username)) {
      return false;
    } else if (!checkInvalid(password)) {
      return false;
    } else if (user == null) {
      errorToast('Username not exits');
      return false;
    } else if (password != user.password) {
      errorToast('Password is incorrect');
      return false;
    }
    await prefs.setString('username', username);
    successToast('Logged in');
    return true;
  }

  static Future<bool> createAccount(
      String name,
      String phoneNumber,
      String username,
      String password,
      String confirmPassword,
      String monthlyPayment) async {
    final prefs = await SharedPreferences.getInstance();

    if (!checkInvalid(name)) {
      return false;
    } else if (!checkInvalid(phoneNumber)) {
      return false;
    } else if (!checkInvalid(username)) {
      return false;
    } else if (!checkInvalid(password)) {
      return false;
    } else if (!checkInvalid(monthlyPayment)) {
      return false;
    } else if (password != confirmPassword) {
      errorToast('Confirm password incorrect');
      return false;
    } else if (!verifyPhoneNumber(phoneNumber)) {
      errorToast('Entered mobile number is invalid');
      return false;
    } else if (int.tryParse(monthlyPayment) == null) {
      errorToast('Monthly payment invalid');
      return false;
    }
    UserModel user = UserModel(
      name: name,
      phoneNumber: int.parse(phoneNumber),
      username: username,
      password: password,
      monthlyPayment: int.parse(monthlyPayment),
    );
    await prefs.setString('username', username);
    return FirebaseService.uploadUser(user);
  }

  static void logout() async {
    // init shared preferences
    SharedPreferences pref = await SharedPreferences.getInstance();
    // remove username in shared preferences
    pref.remove('username');
  }

  static bool verifyPhoneNumber(String number) {
    int? phoneNumber = int.tryParse(number);
    if (phoneNumber != null && number.length == 10) {
      return true;
    }
    return false;
  }

  static bool checkInvalid(String text) {
    if (text == '') {
      errorToast('Invalid field detected');
      return false;
    }
    return true;
  }

  static void errorToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 16.0,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      webBgColor: "linear-gradient(to right, #F44336, #F44336)",
      webPosition: "center",
    );
  }

  static void successToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 16.0,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      webBgColor: "linear-gradient(to right, #4CAF50, #4CAF50)",
      webPosition: "center",
    );
  }
}
