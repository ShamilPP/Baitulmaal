import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../../utils/colors.dart';
import '../../../../view_model/login_view_model.dart';
import '../../../screens/sign_up_screen.dart';
import '../../../screens/splash_screen.dart';
import '../../general/login_text_field.dart';

class LoginContainer extends StatelessWidget {
  LoginContainer({Key? key}) : super(key: key);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController buttonController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height / 1.5;
    if (_height < 400) _height = 400;
    return Container(
      height: _height,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: const BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: primaryColor.withOpacity(.4), blurRadius: 20, offset: const Offset(0, 10))],
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
          Column(
            children: [
              // Login Button
              RoundedLoadingButton(
                  color: primaryColor,
                  successColor: Colors.green,
                  controller: buttonController,
                  onPressed: () => _login(context),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  )),

              const SizedBox(height: 20),

              //SignUp button
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
                      side: MaterialStateProperty.all(BorderSide(width: 2, color: primaryColor))),
                  child: Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20, color: primaryColor),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
                  },
                ),
              ),
            ],
          )
        ],
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
