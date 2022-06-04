import 'package:flutter/material.dart';
import 'package:meekath/view/screens/admin/main_screen.dart';
import 'package:meekath/view/screens/login_screen.dart';
import 'package:meekath/view/screens/user/home_screen.dart';
import 'package:meekath/view_model/admin_view_model.dart';
import 'package:meekath/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    String? username = prefs.getString("username");
    if (username == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } else {
      if (username == "admin") {
        await Provider.of<AdminProvider>(context, listen: false)
            .initData(false);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => AdminMainScreen()));
      } else {
        await Provider.of<UserProvider>(context, listen: false)
            .initData(username);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const UserHomeScreen()));
      }
    }
  }
}
