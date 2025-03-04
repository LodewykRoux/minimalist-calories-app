class CancelRequestException implements Exception {
  final String message;

  CancelRequestException({
    required this.message,
  });

  @override
  String toString() => message;
}
