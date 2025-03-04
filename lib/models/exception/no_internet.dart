class NoInternetException implements Exception {
  final String? message;

  NoInternetException({
    this.message,
  });

  @override
  String toString() => 'Unauthorised Exception: $message';
}
