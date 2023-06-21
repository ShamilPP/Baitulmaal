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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: welcomeText()),
            const Expanded(flex: 2, child: LoginContainer()),
          ],
        ),
      ),
    );
  }
}

Widget welcomeText() {
  return const Padding(
    padding: EdgeInsets.only(left: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Login', style: TextStyle(color: Colors.white, fontSize: 40)),
        SizedBox(height: 10),
        Text('Welcome Back', style: TextStyle(color: Colors.white, fontSize: 18)),
      ],
    ),
  );
}
