import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../widgets/screen/login/login_container.dart';

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
