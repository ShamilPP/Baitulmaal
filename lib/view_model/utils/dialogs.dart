import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../view_model/payment_view_model.dart';
import '../../../../../view_model/utils/calculations.dart';
import '../../utils/constants.dart';
import '../../view/screens/login_screen.dart';
import '../admin_view_model.dart';
import '../authentication_view_model.dart';

void showUpdateDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: const Text('Update is available'),
      content: const Text('Please update to latest version'),
      actions: [
        ElevatedButton(
            onPressed: () {
              launchUrl(Uri.parse(Application.webLink), mode: LaunchMode.externalApplication);
            },
            child: const Text('Update'))
      ],
    ),
  );
}

showLoadingDialog(BuildContext context, String message) {
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

void showMeekathPickerDialog(BuildContext context) {
  var provider = Provider.of<PaymentProvider>(context, listen: false);
  final ValueNotifier<int> currentMeekath = ValueNotifier(provider.meekath);
  var meekathList = getMeekathList();

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
              showLoadingDialog(context, 'Updating...');
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
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text('Are you sure ?'),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(ctx);
            },
          ),
          ElevatedButton(
            child: const Text("Logout"),
            onPressed: () async {
              Navigator.pop(ctx);
              // remove username in shared preferences
              await Provider.of<AuthenticationProvider>(context, listen: false).logout();
              // then, go to login screen
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (_) => const LoginScreen()), (Route<dynamic> route) => false);
            },
          ),
        ],
      );
    },
  );
}
