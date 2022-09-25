import 'package:flutter/material.dart';

class DetailsText extends StatelessWidget {
  final String text;

  const DetailsText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Text(
        text,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }
}
