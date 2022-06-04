import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final bool isNumber;
  final bool neeIcon;

  const LoginTextField({
    Key? key,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.isNumber = false,
    this.neeIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isNumber ? TextInputType.number : null,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            prefixIcon: neeIcon
                ? const Icon(
                    Icons.currency_rupee,
                    color: Colors.black,
                  )
                : null),
      ),
    );
  }
}
