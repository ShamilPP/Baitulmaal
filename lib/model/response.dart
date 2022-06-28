class Response {
  final String? value;
  final bool isSuccessful;
  final String message;

  Response({
    this.value,
    required this.isSuccessful,
    required this.message,
  });
}
