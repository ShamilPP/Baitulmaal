import 'package:baitulmaal/model/payment_model.dart';
import 'package:baitulmaal/model/user_model.dart';

class UserPaymentModel {
  final UserModel user;
  final PaymentModel payment;

  UserPaymentModel({
    required this.user,
    required this.payment,
  });
}
