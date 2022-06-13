import 'package:flutter/material.dart';
import 'package:meekath/service/login_service.dart';

import '../view/screens/login_screen.dart';

class LoginProvider extends ChangeNotifier {
  Future<bool> login(String username, String password) async {
    bool result = await LoginService.loginAccount(username, password);
    return result;
  }

  Future<bool> createAccount(String name, String phoneNumber, String username,
      String password, String confirmPassword, String monthlyPayment) async {
    bool result = await LoginService.createAccount(
        name, phoneNumber, username, password, confirmPassword, monthlyPayment);

    return result;
  }

  logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure ?'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  // remove username in shared preferences
                  LoginService.logout();
                  // then, go to login screen
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (Route<dynamic> route) => false);
                },
                child: const Text('Logout'))
          ],
        );
      },
    );
  }
}
