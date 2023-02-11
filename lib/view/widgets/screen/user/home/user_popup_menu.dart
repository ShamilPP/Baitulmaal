import 'package:baitulmaal/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../../../../../view_model/payment_view_model.dart';
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

  void showMeekathPickerDialog(BuildContext context) {
    var provider = Provider.of<PaymentProvider>(context, listen: false);
    final ValueNotifier<int> currentMeekath = ValueNotifier(provider.meekath);
    var meekathList = provider.getMeekathList();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Select meekath"),
          content: ValueListenableBuilder<int>(
            valueListenable: currentMeekath,
            builder: (ctx, meekath, child) {
              return NumberPicker(
                  value: meekath,
                  minValue: meekathList.first,
                  maxValue: meekathList.last,
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(color: Colors.grey.shade300),
                    bottom: BorderSide(color: Colors.grey.shade300),
                  )),
                  onChanged: (value) => currentMeekath.value = value);
            },
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(ctx);
              },
            ),
            ElevatedButton(
              child: const Text("Select"),
              onPressed: () async {
                // Close meekath selecting dialog
                Navigator.pop(ctx);
                // Then starting loading dialog and update values
                var userProvider = Provider.of<UserProvider>(context, listen: false);
                showLoadingDialog(context, 'Updating...');
                provider.setMeekath(currentMeekath.value);
                await userProvider.loadDataFromFirebase(currentMeekath.value);
                // After close loading dialog
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 30),
              Text(
                message,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        );
      },
    );
  }
}
