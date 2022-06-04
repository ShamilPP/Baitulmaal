import 'package:meekath/model/payment_model.dart';
import 'package:meekath/model/user_model.dart';

class UserPaymentModel {
  final UserModel user;
  final PaymentModel payment;

  UserPaymentModel({
    required this.user,
    required this.payment,
  });
}
