import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  final String title;
  final Widget child;

  const MyAppBar({Key? key, required this.title, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
