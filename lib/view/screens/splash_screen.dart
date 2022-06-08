import 'package:flutter/material.dart';
import 'package:meekath/repo/firebase_service.dart';
import 'package:meekath/utils/constants.dart';
import 'package:meekath/view/screens/admin/main_screen.dart';
import 'package:meekath/view/screens/login_screen.dart';
import 'package:meekath/view/screens/user/home_screen.dart';
import 'package:meekath/view_model/admin_view_model.dart';
import 'package:meekath/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(
              size: 130,
            ),
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 30),
                Text(
                  "Fetching account details",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    final latestVersion = await FirebaseService.getLatestVersion();
    String? username = prefs.getString("username");
    if (latestVersion == version) {
      if (username == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      } else {
        if (username == "admin") {
          // If admin init all data's
          await Provider.of<AdminProvider>(context, listen: false).initData();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => AdminMainScreen()));
        } else {
          // If User init User data's
          await Provider.of<UserProvider>(context, listen: false)
              .initData(username);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const UserHomeScreen()));
        }
      }
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => const UpdateDialog());
    }
  }
}

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Update is available"),
      content: const Text("Please update to latest version"),
      actions: [
        ElevatedButton(
            onPressed: () {
              launchUrl(Uri.parse(webLink),
                  mode: LaunchMode.externalApplication);
            },
            child: const Text("Update"))
      ],
    );
  }
}
