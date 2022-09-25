import 'package:flutter/material.dart';

import '../../../../animations/slide_animation.dart';

class ProfileListTile extends StatelessWidget {
  final String text;
  final String subText;

  const ProfileListTile({
    Key? key,
    required this.text,
    required this.subText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SlideAnimation(
            delay: 600,
            child: Text(
              subText,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 5),
          SlideAnimation(
            delay: 800,
            child: Text(
              text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            thickness: 1,
            height: 10,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
