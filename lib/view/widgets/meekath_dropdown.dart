import 'package:baitulmaal/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/admin_view_model.dart';
import '../../view_model/payment_view_model.dart';

class MeekathDropdown extends StatelessWidget {
  final bool isAdmin;

  const MeekathDropdown({Key? key, required this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(builder: (context, provider, child) {
      return DropdownButton<int>(
        value: provider.meekath,
        items: provider.getAllMeekathList().map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          );
        }).toList(),
        onChanged: (newValue) async {
          provider.showLoadingDialog(context, "Updating...");
          provider.setMeekath(newValue!);
          if (isAdmin) {
            await Provider.of<AdminProvider>(context, listen: false).initData(context);
          } else {
            await Provider.of<UserProvider>(context, listen: false).initData();
          }
          Navigator.pop(context);
        },
      );
    });
  }
}
