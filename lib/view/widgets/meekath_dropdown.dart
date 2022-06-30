import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/admin_view_model.dart';
import '../../view_model/payment_view_model.dart';

class MeekathDropdown extends StatelessWidget {
  final bool update;

  const MeekathDropdown({Key? key, this.update = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(builder: (context, provider, child) {
      return DropdownButton<int>(
        value: provider.meekath,
        items: getAllMeekathList(provider.meekath).map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          );
        }).toList(),
        onChanged: (newValue) async {
          if (update) provider.showLoadingDialog(context, "Updating...");
          provider.setMeekath(newValue!);
          await Provider.of<AdminProvider>(context, listen: false).initData(context);
          if (update) Navigator.pop(context);
        },
      );
    });
  }

  List<int> getAllMeekathList(int meekath) {
    List<int> allMeekath = [];
    for (int i = 2021; i <= DateTime.now().year; i++) {
      allMeekath.add(i);
    }
    return allMeekath;
  }
}
