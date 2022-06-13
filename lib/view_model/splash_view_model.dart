import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/firebase_service.dart';

class SplashProvider extends ChangeNotifier {
  Future<int?> getLatestVersion() async {
    int? latestVersion = await FirebaseService.getLatestVersion();
    return latestVersion;
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    return username;
  }
}
