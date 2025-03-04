class GeneralException implements Exception {
  final StackTrace stackTrace;
  final String message;

  GeneralException({
    required this.message,
    StackTrace? stackTrace,
  }) : stackTrace = identical(stackTrace, StackTrace.empty)
            ? StackTrace.current
            : stackTrace ?? StackTrace.current;

  @override
  String toString() => message;
}
