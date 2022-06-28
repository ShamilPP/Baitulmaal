class PaymentModel {
  final String? docId;
  final String userDocId;
  final int amount;
  final int verify;
  final int meekath;
  final DateTime dateTime;

  PaymentModel({
    this.docId,
    required this.userDocId,
    required this.amount,
    required this.verify,
    required this.meekath,
    required this.dateTime,
  });
}
