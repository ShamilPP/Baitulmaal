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
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Consumer<PaymentProvider>(
            builder: (ctx, provider, child) {
              if (provider.isLoading == null) {
                // If not loading show payment screen
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CloseButton(),
                    Center(
                      child: Column(
                        children: [
                          Text(user.name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          PaymentTextField(controller: paymentController),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            provider.startPayment(
                                context, paymentController.text, user, isAdmin);
                          },
                          child: const Text("PAY")),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("₹", style: TextStyle(fontSize: 35)),
        const SizedBox(width: 5),
        SizedBox(
          width: 100,
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 35),
            decoration: const InputDecoration(
              hintText: " 000",
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }
}
