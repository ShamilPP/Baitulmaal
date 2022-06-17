class LoginResponse {
  final bool isSuccessful;
  final String message;
  final String? username;

  LoginResponse({
    required this.isSuccessful,
    required this.message,
    this.username,
  });
}
