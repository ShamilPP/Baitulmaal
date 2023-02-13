import 'package:flutter/material.dart';

import '../../../../../view_model/utils/dialogs.dart';

class AdminPopupMenu extends StatelessWidget {
  const AdminPopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return {'Meekath', 'Logout'}.map((String choice) {
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
          showLogoutDialog(context);
        }
      },
    );
  }
}
