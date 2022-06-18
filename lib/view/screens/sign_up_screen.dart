import 'package:flutter/material.dart';
import 'package:meekath/view/screens/splash_screen.dart';
import 'package:meekath/view/widgets/my_appbar.dart';
import 'package:meekath/view_model/admin_view_model.dart';
import 'package:meekath/view_model/login_view_model.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/colors.dart';
import '../widgets/login_text_field.dart';

class SignUpScreen extends StatelessWidget {
  final bool isAddUser;

  SignUpScreen({Key? key, this.isAddUser = false}) : super(key: key);

  final RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController monthlyPaymentController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: MyAppBar(
          title: isAddUser ? 'Add new user' : 'Create new account',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 30),
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
                        hint: 'Name',
                        controller: nameController,
                      ),
                      LoginTextField(
                        hint: 'Phone number',
                        controller: phoneNumberController,
                        isNumber: true,
                      ),
                      LoginTextField(
                        hint: 'Username',
                        controller: usernameController,
                      ),
                      LoginTextField(
                        hint: 'Password',
                        controller: passwordController,
                        isPassword: true,
                      ),
                      LoginTextField(
                        hint: 'Confirm password',
                        controller: confirmPasswordController,
                        isPassword: true,
                      ),
                      LoginTextField(
                        hint: 'Monthly payment',
                        controller: monthlyPaymentController,
                        isNumber: true,
                        neeIcon: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                // Login Button
                RoundedLoadingButton(
                  color: primaryColor,
                  successColor: Colors.green,
                  child: Text(
                    isAddUser ? 'Add' : 'Sign up',
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  controller: buttonController,
                  onPressed: () => _createAccount(context, !isAddUser),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void _createAccount(BuildContext context, bool isLogin) async {
    LoginProvider provider = Provider.of<LoginProvider>(context, listen: false);
    bool success = await provider.createAccount(
      nameController.text,
      phoneNumberController.text,
      usernameController.text,
      passwordController.text,
      confirmPasswordController.text,
      monthlyPaymentController.text,
      isLogin,
    );
    if (success) {
      buttonController.success();
      await Future.delayed(const Duration(milliseconds: 500));
      // if admin add user
      if (isAddUser) {
        Provider.of<AdminProvider>(context, listen: false).initData();
        Navigator.pop(context);
      } else {
        // if create account go to splash screen
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SplashScreen()),
            (Route<dynamic> route) => false);
      }
    } else {
      buttonController.error();
      await Future.delayed(const Duration(seconds: 2));
      buttonController.reset();
    }
  }
}
