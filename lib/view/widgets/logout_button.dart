import 'package:flutter/material.dart';

import '../../repo/login_service.dart';
import '../../utils/colors.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 45,
      child: TextButton(
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
