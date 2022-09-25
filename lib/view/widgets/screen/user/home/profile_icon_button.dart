import 'package:flutter/material.dart';

import '../../../../../model/user_model.dart';
import '../../../../../utils/colors.dart';
import '../../../../screens/user/profile_screen.dart';

class ProfileIconButton extends StatelessWidget {
  final UserModel user;

  const ProfileIconButton({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.4),
          blurRadius: 7,
        )
      ]),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          splashColor: Colors.black,
          borderRadius: BorderRadius.circular(30),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.account_circle_outlined,
              size: 30,
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(user: user)));
          },
        ),
      ),
    );
  }
}
