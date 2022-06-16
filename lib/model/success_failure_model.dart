class SuccessFailModel {
  final bool isSucceed;
  final String message;
  final String? username;

  SuccessFailModel(
      {required this.isSucceed, required this.message, this.username});
}
