import 'package:baitulmaal/service/local_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../service/firebase_service.dart';
import '../utils/constants.dart';

class SplashProvider extends ChangeNotifier {
  Future<int> getMajorVersion() async {
    int majorVersion = await FirebaseService.getMajorVersion();
    return majorVersion;
  }

  Future<String?> getDocId() async {
    String? docId = await LocalService.getUser();
    return docId;
  }

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
                launchUrl(Uri.parse(webLink), mode: LaunchMode.externalApplication);
              },
              child: const Text('Update'))
        ],
      ),
    );
  }
}
