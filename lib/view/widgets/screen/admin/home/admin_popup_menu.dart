import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../../../../../view_model/admin_view_model.dart';
import '../../../../../view_model/payment_view_model.dart';

class AdminPopupMenu extends StatelessWidget {
  const AdminPopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<PaymentProvider>(context, listen: false);
    final ValueNotifier<int> currentMeekath = ValueNotifier(provider.meekath);
    var meekathList = provider.getMeekathList();

    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return {'Meekath'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
      onSelected: (value) {
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
                    var adminProvider = Provider.of<AdminProvider>(context, listen: false);
                    adminProvider.showLoadingDialog(context, 'Updating...');
                    provider.setMeekath(currentMeekath.value);
                    await adminProvider.loadDataFromFirebase(context);
                    // After close loading dialog
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}