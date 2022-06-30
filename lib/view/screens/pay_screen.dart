import 'package:baitulmaal/model/user_model.dart';
import 'package:baitulmaal/utils/enums.dart';
import 'package:baitulmaal/view/widgets/meekath_dropdown.dart';
import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/animated_check.dart';

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
              if (provider.uploadStatus == PayUploadStatus.none) {
                // If not loading show payment screen
                return Stack(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CloseButton(),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //User details
                          const Icon(
                            Icons.account_circle,
                            size: 70,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${user.name} paying",
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "+91 ${user.phoneNumber}",
                            style: const TextStyle(fontSize: 18),
                          ),
                          // Meekath Dropdown (Change meekath year)
                          isAdmin ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Meekath  :  "),
                              MeekathDropdown(update: false),
                            ],
                          ) : const SizedBox(),
                          const SizedBox(height: 30),
                          // Payment TextField
                          PaymentTextField(controller: paymentController),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                    // Pay button
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'PAY',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          onPressed: () {
                            provider.uploadPayment(context, paymentController.text, user, isAdmin);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return AnimatedCheck(status: provider.uploadStatus);
              }
            },
          ),
        ),
      ),
    );
  }
}

class PaymentTextField extends StatelessWidget {
  final TextEditingController controller;

  const PaymentTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.blue.shade100.withOpacity(.8), borderRadius: BorderRadius.circular(10)),
      child: IntrinsicWidth(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('₹', style: TextStyle(fontSize: 35)),
            const SizedBox(width: 8),
            IntrinsicWidth(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 35),
                decoration: const InputDecoration(
                  hintText: '000',
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
