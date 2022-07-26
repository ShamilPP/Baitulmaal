import 'package:baitulmaal/utils/colors.dart';
import 'package:baitulmaal/utils/constants.dart';
import 'package:baitulmaal/view/screens/admin/main_screen.dart';
import 'package:baitulmaal/view/screens/login_screen.dart';
import 'package:baitulmaal/view/screens/user/home_screen.dart';
import 'package:baitulmaal/view_model/admin_view_model.dart';
import 'package:baitulmaal/view_model/splash_view_model.dart';
import 'package:baitulmaal/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
              children: [
                loadingAnimation(),
                const SizedBox(width: 20),
                const Text(
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

  Widget loadingAnimation() {
    return SizedBox(
      width: 45,
      height: 45,
      child: SpinKitSpinningLines(
        color: primaryColor,
      ),
    );
  }

  void init() async {
    SplashProvider provider = Provider.of<SplashProvider>(context, listen: false);
    int _updateCode = await provider.getUpdateCode();
    String? docId = await provider.getDocId();
    if (_updateCode != Application.updateCode) {
      // If this is not matching update code show update dialog
      provider.showUpdateDialog(context);
    } else {
      if (docId == null) {
        // if not logged in
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      } else {
        // if logged in
        if (docId == 'admin') {
          // If admin, init all data's
          await Provider.of<AdminProvider>(context, listen: false).loadDataFromFirebase(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminMainScreen()));
        } else {
          // If User, init User data's
          UserProvider provider = Provider.of<UserProvider>(context, listen: false);
          provider.setDocID(docId);
          await provider.initData();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UserHomeScreen()));
        }
      }
    }
  }
}
