import 'package:flutter/material.dart';

import '../../../../animations/slide_animation.dart';

class PasswordListTile extends StatefulWidget {
  final String password;

  const PasswordListTile({
    Key? key,
    required this.password,
  }) : super(key: key);

  @override
  State<PasswordListTile> createState() => _PasswordListTileState();
}

class _PasswordListTileState extends State<PasswordListTile> {
  bool isShowing = false;
  late String text = getHidePassword();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SlideAnimation(
                    delay: 600,
                    child: Text(
                      'Password',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
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
                ],
              ),
              SlideAnimation(
                delay: 1000,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Icon(
                      isShowing ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      isShowing = !isShowing;
                      if (isShowing) {
                        text = widget.password;
                      } else {
                        text = getHidePassword();
                      }
                    });
                  },
                ),
              )
            ],
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

  String getHidePassword() {
    String pass = '';
    for (int i = 0; i < widget.password.length; i++) {
      pass = '$pass•';
    }
    return pass;
  }
}
