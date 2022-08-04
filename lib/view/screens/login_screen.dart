import 'package:baitulmaal/view/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/colors.dart';
import '../../view_model/login_view_model.dart';
import '../widgets/login_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: primaryColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              welcomeText(),
              const SizedBox(height: 100),
              LoginContainer(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget welcomeText() {
  return Padding(
    padding: const EdgeInsets.only(left: 20, top: 80),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text('Login', style: TextStyle(color: Colors.white, fontSize: 40)),
        SizedBox(height: 10),
        Text('Welcome Back', style: TextStyle(color: Colors.white, fontSize: 18)),
      ],
    ),
  );
}

class LoginContainer extends StatelessWidget {
  LoginContainer({Key? key}) : super(key: key);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController buttonController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height-300;
    if (400 > _height) {
      _height = 400;
    }
    return Container(
      height: _height,
      padding: const EdgeInsets.only(top: 50),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: primaryColor.withOpacity(.4), blurRadius: 20, offset: const Offset(0, 10))
                ],
              ),
              child: Column(
                children: <Widget>[
                  // TextField
                  LoginTextField(
                    hint: 'Username',
                    controller: usernameController,
                  ),
                  LoginTextField(
                    hint: 'Password',
                    controller: passwordController,
                    isPassword: true,
                  ),
                ],
              ),
            ),

            // Login Button
            RoundedLoadingButton(
                color: primaryColor,
                successColor: Colors.green,
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                controller: buttonController,
                onPressed: () => _login(context)),
          ],
        ),
      ),
    );
  }

  _login(BuildContext context) async {
    LoginProvider provider = Provider.of<LoginProvider>(context, listen: false);
    bool status = await provider.login(usernameController.text, passwordController.text);
    if (status) {
      buttonController.success();
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SplashScreen()));
    } else {
      buttonController.error();
      await Future.delayed(const Duration(seconds: 2));
      buttonController.reset();
    }
  }
}
