import 'package:flutter/material.dart';
import 'package:meekath/model/user_model.dart';
import 'package:meekath/view_model/payment_view_model.dart';
import 'package:provider/provider.dart';

import '../widgets/animated_check.dart';

class PayScreen extends StatelessWidget {
  final UserModel user;
  final bool isAdmin;

  PayScreen({Key? key, required this.user, required this.isAdmin})
      : super(key: key);

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
              if (provider.isLoading == null) {
                // If not loading show payment screen
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CloseButton(),
                        // User details
                        const SizedBox(height: 30),
                        Center(
                          child: Text(
                            "${user.name} paying",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    // Payment TextField
                    Center(
                        child: PaymentTextField(controller: paymentController)),
                    // Pay button
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.green),
                          child: const Text(
                            'PAY',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          onPressed: () {
                            provider.uploadPayment(
                                context, paymentController.text, user, isAdmin);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return AnimatedCheck(isLoading: provider.isLoading!);
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

  const PaymentTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.blue.shade100.withOpacity(.8),
          borderRadius: BorderRadius.circular(10)),
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
