import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meekath/utils/colors.dart';
import 'package:meekath/view/screens/splash_screen.dart';
import 'package:meekath/view_model/admin_view_model.dart';
import 'package:meekath/view_model/payment_view_model.dart';
import 'package:meekath/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],
      child: MaterialApp(
        title: 'Meekath',
        theme: ThemeData(
          primarySwatch: primarySwatch,
          scaffoldBackgroundColor: backgroundColor,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
