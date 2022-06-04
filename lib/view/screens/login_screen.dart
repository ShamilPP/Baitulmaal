import 'package:flutter/material.dart';
import 'package:meekath/repo/login_service.dart';
import 'package:meekath/view/screens/create_account_screen.dart';
import 'package:meekath/view/screens/splash_screen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../widgets/login_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),
            const WelcomeText(),
            const SizedBox(height: 20),
            LoginContainer(),
          ],
        ),
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  const WelcomeText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("Login", style: TextStyle(color: Colors.white, fontSize: 40)),
          SizedBox(height: 10),
          Text("Welcome Back",
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }
}

class LoginContainer extends StatelessWidget {
  LoginContainer({Key? key}) : super(key: key);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60), topRight: Radius.circular(60))),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 100),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: primaryColor.withOpacity(.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10))
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      // TextField
                      LoginTextField(
                        hint: "Username",
                        controller: usernameController,
                      ),
                      LoginTextField(
                        hint: "Password",
                        controller: passwordController,
                        isPassword: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                // Login Button
                RoundedLoadingButton(
                    color: primaryColor,
                    successColor: Colors.green,
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    controller: buttonController,
                    onPressed: () => _login(context)),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: OutlinedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        side: MaterialStateProperty.all(
                            BorderSide(width: 2, color: primaryColor))),
                    child: Text(
                      "Create new account",
                      style: TextStyle(fontSize: 18, color: primaryColor),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CreateAccountScreen()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _login(BuildContext context) async {
    int status = await LoginService.loginAccount(
        usernameController.text, passwordController.text);
    if (status == loginSuccess) {
      buttonController.success();
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const SplashScreen()));
    } else if (status == loginFailed) {
      buttonController.error();
      await Future.delayed(const Duration(seconds: 2));
      buttonController.reset();
    }
  }
}
