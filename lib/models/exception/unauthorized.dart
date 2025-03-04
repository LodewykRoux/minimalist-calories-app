class UnauthorisedException implements Exception {
  final StackTrace stackTrace;
  final String? message;

  UnauthorisedException({
    this.message,
    StackTrace? stackTrace,
  }) : stackTrace = identical(stackTrace, StackTrace.empty)
            ? StackTrace.current
            : stackTrace ?? StackTrace.current;

  @override
  String toString() => 'Unauthorised Exception: $message';
}
