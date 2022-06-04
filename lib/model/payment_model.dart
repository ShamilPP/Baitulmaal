class PaymentModel {
  final String docId;
  final int amount;
  final int verify;
  final DateTime dateTime;

  PaymentModel({
    required this.docId,
    required this.amount,
    required this.verify,
    required this.dateTime,
  });
}
