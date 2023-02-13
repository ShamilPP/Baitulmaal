import 'package:baitulmaal/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../view_model/utils/dialogs.dart';
import '../../../../screens/user/profile_screen.dart';

class UserPopupMenu extends StatelessWidget {
  const UserPopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return {'Meekath', 'Profile'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
      onSelected: (value) {
        if (value == 'Meekath') {
          showMeekathPickerDialog(context);
        } else {
          var user = Provider.of<UserProvider>(context, listen: false).user;
          Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(user: user)));
        }
      },
    );
  }
}
