import 'package:baitulmaal/model/user.dart';

class Payment {
  final String? docId;
  final String? userDocId;
  final User? user;
  final int amount;
  int verify;
  final int meekath;
  final DateTime dateTime;

  Payment({
    this.docId,
    this.userDocId,
    this.user,
    required this.amount,
    required this.verify,
    required this.meekath,
    required this.dateTime,
  });
}
