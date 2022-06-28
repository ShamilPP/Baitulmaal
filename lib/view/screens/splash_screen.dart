import 'package:baitulmaal/utils/constants.dart';
import 'package:baitulmaal/view/screens/admin/main_screen.dart';
import 'package:baitulmaal/view/screens/login_screen.dart';
import 'package:baitulmaal/view/screens/user/home_screen.dart';
import 'package:baitulmaal/view_model/admin_view_model.dart';
import 'package:baitulmaal/view_model/splash_view_model.dart';
import 'package:baitulmaal/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                  'Fetching account details',
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
    SplashProvider provider = Provider.of<SplashProvider>(context, listen: false);
    int _majorVersion = await provider.getMajorVersion();
    String? username = await provider.getUsername();
    if (_majorVersion != majorVersion) {
      // If this is not the major version
      provider.showUpdateDialog(context);
    } else {
      if (username == null) {
        // if not logged in
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      } else {
        // if logged in
        if (username == 'admin') {
          // If admin, init all data's
          await Provider.of<AdminProvider>(context, listen: false).initData(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminMainScreen()));
        } else {
          // If User, init User data's
          await Provider.of<UserProvider>(context, listen: false).initData(username);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UserHomeScreen()));
        }
      }
    }
  }
}
