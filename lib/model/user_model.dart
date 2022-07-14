import 'package:baitulmaal/model/payment_model.dart';
import 'package:baitulmaal/model/total_analytics_model.dart';

class UserModel {
  final String? docId;
  final String name;
  final int phoneNumber;
  final String username;
  final String password;
  final int monthlyPayment;
  final TotalAnalyticsModel? analytics;
  final List<PaymentModel>? payments;

  UserModel({
    this.docId,
    required this.name,
    required this.phoneNumber,
    required this.username,
    required this.password,
    required this.monthlyPayment,
    this.analytics,
    this.payments,
  });
}
