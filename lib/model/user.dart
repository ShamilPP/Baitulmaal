import 'package:baitulmaal/model/analytics.dart';

class User {
  final String? docId;
  final String name;
  final int phoneNumber;
  final String username;
  final String password;
  final Map<int, int> monthlyPayment;
  Analytics? analytics;

  User({
    this.docId,
    required this.name,
    required this.phoneNumber,
    required this.username,
    required this.password,
    required this.monthlyPayment,
    this.analytics,
  });
}
