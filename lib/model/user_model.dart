class UserModel {
  final String? docId;
  final String name;
  final int phoneNumber;
  final String username;
  final String password;
  final int monthlyPayment;

  UserModel({
    this.docId,
    required this.name,
    required this.phoneNumber,
    required this.username,
    required this.password,
    required this.monthlyPayment,
  });
}
