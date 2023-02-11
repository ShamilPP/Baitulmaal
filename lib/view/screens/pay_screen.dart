import 'package:baitulmaal/model/user_model.dart';
import 'package:baitulmaal/utils/enums.dart';
import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:baitulmaal/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/admin_view_model.dart';
import '../animations/slide_animation.dart';
import '../widgets/screen/pay/animated_check.dart';
import '../widgets/screen/pay/payment_text_field.dart';

class PayScreen extends StatelessWidget {
  final UserModel user;
  final bool isAdmin;

  PayScreen({Key? key, required this.user, required this.isAdmin}) : super(key: key);

  final TextEditingController paymentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Consumer<PaymentProvider>(
            builder: (ctx, provider, child) {
              switch (provider.uploadStatus) {
                case Status.none:
                  return body(context);
                case Status.loading:
                  return const Center(
                      child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(strokeWidth: 7),
                  ));
                case Status.completed:
                  return const AnimatedCheckMark(color: Colors.green, icon: Icons.check);
                case Status.failed:
                  return const AnimatedCheckMark(color: Colors.red, icon: Icons.close);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    return Stack(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SlideAnimation(delay: 100, child: CloseButton()),
        Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //User details
                const SlideAnimation(
                  delay: 200,
                  child: Icon(
                    Icons.account_circle,
                    size: 70,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                SlideAnimation(
                  delay: 300,
                  child: Text(
                    "${user.name} paying",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                SlideAnimation(
                  delay: 400,
                  child: Text(
                    "+91 ${user.phoneNumber}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                // Meekath Dropdown (Change meekath year)
                SlideAnimation(
                  delay: 500,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Meekath  :  "),
                      meekathDropDown(),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Payment TextField
                SlideAnimation(delay: 600, child: PaymentTextField(controller: paymentController)),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        // Pay button
        Align(
          alignment: Alignment.bottomCenter,
          child: SlideAnimation(
            delay: 800,
            child: SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'PAY',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () {
                  var provider = Provider.of<PaymentProvider>(context, listen: false);
                  provider.uploadPayment(context, paymentController.text, user, isAdmin);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget meekathDropDown() {
    return Consumer<PaymentProvider>(builder: (context, provider, child) {
      return DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: provider.meekath,
          items: provider.getMeekathList().map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value'),
            );
          }).toList(),
          onChanged: (newValue) async {
            provider.setMeekath(newValue!);
            if (isAdmin) {
              await Provider.of<AdminProvider>(context, listen: false).loadDataFromFirebase(context);
            } else {
              Provider.of<UserProvider>(context, listen: false).initData(newValue);
            }
          },
        ),
      );
    });
  }
}
