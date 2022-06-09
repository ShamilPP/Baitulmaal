class AdminOverviewModel {
  final int totalUsers;
  final int pendingUsers;
  final int totalAmount;
  final int totalReceivedAmount;
  final int pendingAmount;
  final int extraAmount;

  AdminOverviewModel({
    required this.totalUsers,
    required this.pendingUsers,
    required this.totalAmount,
    required this.totalReceivedAmount,
    required this.pendingAmount,
    required this.extraAmount,
  });
}
