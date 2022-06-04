import 'package:flutter/material.dart';
import 'package:meekath/repo/login_service.dart';

import '../../utils/colors.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 45,
      child: OutlinedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            side: MaterialStateProperty.all(
                BorderSide(width: 2, color: primaryColor))),
        child: Text(
          "Logout",
          style: TextStyle(fontSize: 20, color: primaryColor),
        ),
        onPressed: () {
          LoginService.logout(context);
        },
      ),
    );
  }
}
