import 'package:baitulmaal/utils/colors.dart';
import 'package:baitulmaal/view/screens/splash_screen.dart';
import 'package:baitulmaal/view_model/admin_view_model.dart';
import 'package:baitulmaal/view_model/login_view_model.dart';
import 'package:baitulmaal/view_model/navigation_view_model.dart';
import 'package:baitulmaal/view_model/payment_view_model.dart';
import 'package:baitulmaal/view_model/request_view_model.dart';
import 'package:baitulmaal/view_model/splash_view_model.dart';
import 'package:baitulmaal/view_model/user_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => RequestProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: MaterialApp(
        title: 'Baitulmaal',
        theme: ThemeData(
          primarySwatch: primarySwatch,
          scaffoldBackgroundColor: backgroundColor,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
