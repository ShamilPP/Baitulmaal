class UserAnalyticsModel {
  final int totalAmount;
  final int totalReceivedAmount;
  final int pendingAmount;
  final bool isPending;

  UserAnalyticsModel({
    required this.totalAmount,
    required this.totalReceivedAmount,
    required this.pendingAmount,
    required this.isPending,
  });
}
