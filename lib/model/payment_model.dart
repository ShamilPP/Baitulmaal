import 'package:baitulmaal/model/user_model.dart';

class PaymentModel {
  final String? docId;
  final String? userDocId;
  final UserModel? user;
  final int amount;
  int verify;
  final int meekath;
  final DateTime dateTime;

  PaymentModel({
    this.docId,
    this.userDocId,
    this.user,
    required this.amount,
    required this.verify,
    required this.meekath,
    required this.dateTime,
  });
}
