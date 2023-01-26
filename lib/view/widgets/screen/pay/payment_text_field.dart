import 'package:flutter/material.dart';

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
