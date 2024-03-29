import 'package:baitulmaal/utils/constants.dart';
import 'package:baitulmaal/view/screens/admin/main_screen.dart';
import 'package:baitulmaal/view/screens/login_screen.dart';
import 'package:baitulmaal/view/screens/user/home_screen.dart';
import 'package:baitulmaal/view_model/admin_view_model.dart';
import 'package:baitulmaal/view_model/splash_view_model.dart';
import 'package:baitulmaal/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/utils/dialogs.dart';
import '../widgets/general/loading_widget.dart';

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
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(
              size: 130,
            ),
            SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 45, height: 45, child: LoadingWidget()), // Loading animation
                SizedBox(width: 20),
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
    int _updateCode = await provider.getUpdateCode();
    String? docId = await provider.getDocId();
    if (_updateCode != Application.updateCode) {
      // If this is not matching update code show update dialog
      showUpdateDialog(context);
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
          await provider.loadDataFromFirebase(DateTime.now().year);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UserHomeScreen()));
        }
      }
    }
  }
}
